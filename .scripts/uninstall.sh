#!/bin/bash

# Script para desinstalar dotfiles
# Remove symlinks e restaura backups se existirem

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

echo "=================================="
echo "   DESINSTALAÇÃO DE DOTFILES"
echo "=================================="
echo

# Lista completa de configurações para remover
declare -A CONFIGS=(
  ["Fish Shell"]="$HOME/.config/fish"
  ["Neovim"]="$HOME/.config/nvim"
  ["Tmux"]="$HOME/.config/tmux"
  ["Yazi"]="$HOME/.config/yazi"
  ["Ghostty"]="$HOME/.config/ghostty"
  ["LazyGit"]="$HOME/.config/lazygit"
  ["Mise"]="$HOME/.config/mise"
  ["Starship"]="$HOME/.config/starship.toml"
  ["WezTerm"]="$HOME/.config/wezterm"
  ["Bat"]="$HOME/.config/bat"
  ["Scripts Personalizados"]="$HOME/.scripts"
  ["Git Config"]="$HOME/.gitconfig"
  ["Git Ignore Global"]="$HOME/.gitignore"
)

# Função para confirmar ação
confirm_action() {
  local message=$1
  local default=${2:-n}
  
  if [[ $default == "y" ]]; then
    prompt="$message (Y/n): "
  else
    prompt="$message (y/N): "
  fi
  
  read -p "$prompt" -n 1 -r
  echo
  
  if [[ $default == "y" ]]; then
    [[ $REPLY =~ ^[Nn]$ ]] && return 1 || return 0
  else
    [[ $REPLY =~ ^[Yy]$ ]] && return 0 || return 1
  fi
}

# Função para encontrar backup mais recente
find_latest_backup() {
  local target_path=$1
  local backup_base="$HOME/.dotfiles-backup"
  
  if [[ ! -d "$backup_base" ]]; then
    return 1
  fi
  
  # Procurar pelo backup mais recente que contém o arquivo/diretório
  local relative_path="${target_path#$HOME/}"
  local latest_backup=""
  local latest_time=0
  
  for backup_dir in "$backup_base"/*; do
    if [[ -d "$backup_dir" ]] && [[ -e "$backup_dir/$relative_path" ]]; then
      local backup_time=$(stat -c %Y "$backup_dir" 2>/dev/null || echo 0)
      if [[ $backup_time -gt $latest_time ]]; then
        latest_time=$backup_time
        latest_backup="$backup_dir/$relative_path"
      fi
    fi
  done
  
  if [[ -n "$latest_backup" ]]; then
    echo "$latest_backup"
    return 0
  else
    return 1
  fi
}

# Função para remover symlink e restaurar backup
remove_config() {
  local name=$1
  local path=$2
  
  log_info "Processando: $name"
  
  if [[ -L "$path" ]]; then
    rm "$path"
    log_success "Symlink removido: $path"
    
    # Tentar restaurar backup
    if backup_path=$(find_latest_backup "$path"); then
      if confirm_action "Restaurar backup para $name?"; then
        mkdir -p "$(dirname "$path")"
        mv "$backup_path" "$path"
        log_success "Backup restaurado: $path"
      fi
    else
      log_info "Nenhum backup encontrado para $name"
    fi
    
  elif [[ -e "$path" ]]; then
    log_warning "$name existe mas não é um symlink: $path"
    if confirm_action "Remover $name manualmente?"; then
      if [[ -d "$path" ]]; then
        rm -rf "$path"
      else
        rm -f "$path"
      fi
      log_success "Removido: $path"
    fi
  else
    log_info "$name não encontrado: $path"
  fi
}

# Verificar se há configurações para remover
has_configs=false
for path in "${CONFIGS[@]}"; do
  if [[ -e "$path" ]]; then
    has_configs=true
    break
  fi
done

if [[ "$has_configs" == "false" ]]; then
  log_info "Nenhuma configuração de dotfiles encontrada"
  exit 0
fi

# Confirmar desinstalação
echo "ATENÇÃO: Esta operação irá:"
echo "1. Remover todos os symlinks dos dotfiles"
echo "2. Tentar restaurar backups quando disponíveis"
echo "3. Limpar configurações do PATH (scripts personalizados)"
echo "4. Reverter configurações do Git global"
echo

if ! confirm_action "Deseja continuar com a desinstalação?"; then
  log_info "Desinstalação cancelada"
  exit 0
fi

log_info "Iniciando desinstalação..."
echo

# Remover configurações
for name in "${!CONFIGS[@]}"; do
  remove_config "$name" "${CONFIGS[$name]}"
  echo
done

# Limpar configurações específicas
log_info "Limpando configurações específicas..."

# Remover scripts do PATH
if [[ -f "$HOME/.bashrc" ]]; then
  if grep -q 'export PATH="$HOME/.scripts:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
    sed -i '/export PATH="\$HOME\/\.scripts:\$PATH"/d' "$HOME/.bashrc"
    log_success "Scripts removidos do PATH (.bashrc)"
  fi
fi

if [[ -f "$HOME/.config/fish/config.fish" ]]; then
  if grep -q 'set -gx PATH $HOME/.scripts $PATH' "$HOME/.config/fish/config.fish" 2>/dev/null; then
    sed -i '/set -gx PATH \$HOME\/\.scripts \$PATH/d' "$HOME/.config/fish/config.fish"
    log_success "Scripts removidos do PATH (fish)"
  fi
fi

# Reverter configuração do Git ignore global
current_excludes=$(git config --global core.excludesfile 2>/dev/null || echo "")
if [[ "$current_excludes" == "$HOME/.gitignore" ]]; then
  git config --global --unset core.excludesfile 2>/dev/null || true
  log_success "Configuração de gitignore global removida"
fi

# Perguntar sobre mudança de shell padrão
if [[ "$SHELL" == *"fish"* ]]; then
  if confirm_action "Fish é seu shell padrão. Deseja voltar para bash?"; then
    chsh -s /bin/bash
    log_success "Shell padrão alterado para bash"
  fi
fi

# Opções de limpeza adicional
echo
log_info "Opções de limpeza adicional:"

# Limpar backups antigos
if [[ -d "$HOME/.dotfiles-backup" ]]; then
  backup_count=$(find "$HOME/.dotfiles-backup" -maxdepth 1 -type d | wc -l)
  if [[ $backup_count -gt 1 ]]; then
    if confirm_action "Remover todos os backups em ~/.dotfiles-backup/?"; then
      rm -rf "$HOME/.dotfiles-backup"
      log_success "Backups removidos"
    else
      log_info "Backups mantidos em ~/.dotfiles-backup/"
    fi
  fi
fi

# Verificar sessões do Tmux
if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null; then
  if confirm_action "Há sessões ativas do Tmux. Deseja encerrá-las?"; then
    tmux kill-server 2>/dev/null || true
    log_success "Sessões do Tmux encerradas"
  fi
fi

# Cache do Bat
if command -v bat &>/dev/null; then
  if confirm_action "Reconstruir cache padrão do Bat (remover temas customizados)?"; then
    bat cache --clear 2>/dev/null || true
    bat cache --build 2>/dev/null || true
    log_success "Cache do Bat resetado"
  fi
fi

# Verificação final
echo
log_info "Verificando remoção..."

remaining_configs=0
for name in "${!CONFIGS[@]}"; do
  path="${CONFIGS[$name]}"
  if [[ -e "$path" ]]; then
    log_warning "Ainda existe: $name -> $path"
    ((remaining_configs++))
  fi
done

echo
echo "=================================="
echo "   RESUMO DA DESINSTALAÇÃO"
echo "=================================="

if [[ $remaining_configs -eq 0 ]]; then
  log_success "Desinstalação completa! Todas as configurações foram removidas."
else
  log_warning "$remaining_configs configuração(ões) ainda existem"
  echo "Você pode removê-las manualmente se necessário."
fi

echo
echo "Próximos passos:"
echo "1. Reinicie seu terminal para aplicar mudanças no PATH e shell"
echo "2. Verifique se as configurações padrão estão funcionando"
echo "3. Remova ferramentas que não usa mais (fish, nvim, etc.)"
echo "4. Considere limpar diretórios ~/.cache relacionados às ferramentas"
echo

if [[ -d "$HOME/.dotfiles-backup" ]]; then
  echo "Backups ainda disponíveis em: ~/.dotfiles-backup/"
fi

log_success "Desinstalação concluída!"
