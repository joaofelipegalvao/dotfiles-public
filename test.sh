#!/bin/bash

# Script para testar se as configurações estão funcionando
# Execute após a instalação para verificar os symlinks

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
  echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
  echo -e "${RED}[✗]${NC} $1"
}

echo "=================================="
echo "   TESTE DE CONFIGURAÇÕES"
echo "=================================="
echo

# Lista de symlinks para verificar
declare -A CONFIGS=(
  ["Fish Shell"]="$HOME/.config/fish"
  ["Neovim"]="$HOME/.config/nvim"
  ["Tmux (config dir)"]="$HOME/.config/tmux"
  ["Tmux (conf file)"]="$HOME/.tmux.conf"
  ["Yazi"]="$HOME/.config/yazi"
  ["Ghostty"]="$HOME/.config/ghostty"
  ["LazyGit"]="$HOME/.config/lazygit"
  ["Mise"]="$HOME/.config/mise"
  ["Starship"]="$HOME/.config/starship.toml"
  ["Git Config"]="$HOME/.gitconfig"
  ["Git Ignore Global"]="$HOME/.gitignore_global"
)

log_info "Verificando symlinks..."
echo

for name in "${!CONFIGS[@]}"; do
  path="${CONFIGS[$name]}"

  if [[ -L "$path" ]]; then
    target=$(readlink "$path")
    if [[ -e "$target" ]]; then
      log_success "$name: $path -> $target"
    else
      log_error "$name: Symlink quebrado -> $target"
    fi
  elif [[ -e "$path" ]]; then
    log_warning "$name: Existe mas não é symlink -> $path"
  else
    log_warning "$name: Não encontrado -> $path"
  fi
done

echo
log_info "Verificando comandos disponíveis..."
echo

# Verificar se as ferramentas estão instaladas
tools=("fish" "nvim" "tmux" "yazi" "lazygit" "mise" "starship")

for tool in "${tools[@]}"; do
  if command -v "$tool" &>/dev/null; then
    version=$(command -v "$tool" && $tool --version 2>/dev/null | head -n1 || echo "versão não disponível")
    log_success "$tool: $(which $tool)"
  else
    log_error "$tool: Não instalado"
  fi
done

echo
log_info "Verificando configurações específicas..."
echo

# Verificar Fish plugins se Fisher estiver instalado
if command -v fish &>/dev/null && [[ -f "$HOME/.config/fish/fish_plugins" ]]; then
  plugin_count=$(wc -l <"$HOME/.config/fish/fish_plugins" 2>/dev/null || echo "0")
  log_info "Fish plugins configurados: $plugin_count"
fi

# Verificar se o Git está usando o gitignore global
if [[ -f "$HOME/.gitignore_global" ]]; then
  global_ignore=$(git config --global core.excludesfile 2>/dev/null || echo "não configurado")
  if [[ "$global_ignore" == "$HOME/.gitignore_global" ]]; then
    log_success "Git ignore global configurado corretamente"
  else
    log_warning "Git ignore global: $global_ignore"
  fi
fi

# Verificar se Fish é o shell padrão
if [[ "$SHELL" == *"fish"* ]]; then
  log_success "Fish é o shell padrão"
else
  log_info "Shell atual: $SHELL"
fi

echo
echo "=================================="
echo "   RESUMO DO TESTE"
echo "=================================="

# Contar symlinks válidos
valid_symlinks=0
total_configs=${#CONFIGS[@]}

for path in "${CONFIGS[@]}"; do
  if [[ -L "$path" ]] && [[ -e "$(readlink "$path")" ]]; then
    ((valid_symlinks++))
  fi
done

echo "Symlinks válidos: $valid_symlinks/$total_configs"

if [[ $valid_symlinks -eq $total_configs ]]; then
  log_success "Todas as configurações estão funcionando!"
else
  log_warning "Algumas configurações podem precisar de atenção"
fi

echo
echo "Para testar individualmente:"
echo "  fish -c 'echo Fish funcionando!'"
echo "  nvim --version"
echo "  tmux list-sessions 2>/dev/null || echo 'Nenhuma sessão tmux ativa'"
echo "  yazi --version"
echo "  lazygit --version"
echo "  mise --version"
echo "  starship --version"
