#!/bin/bash

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

# Lista atualizada de symlinks para verificar
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

# Lista atualizada de ferramentas para verificar
tools=("fish" "nvim" "tmux" "yazi" "lazygit" "mise" "starship" "wezterm" "bat")

for tool in "${tools[@]}"; do
  if command -v "$tool" &>/dev/null; then
    case "$tool" in
      "wezterm")
        version=$(wezterm --version 2>/dev/null | head -n1 || echo "versão não disponível")
        ;;
      "bat")
        version=$(bat --version 2>/dev/null | head -n1 || echo "versão não disponível")
        ;;
      *)
        version=$($tool --version 2>/dev/null | head -n1 || echo "versão não disponível")
        ;;
    esac
    log_success "$tool: $(which $tool) - $version"
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
if [[ -f "$HOME/.gitignore" ]]; then
  global_ignore=$(git config --global core.excludesfile 2>/dev/null || echo "não configurado")
  if [[ "$global_ignore" == "$HOME/.gitignore" ]]; then
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

# Verificar scripts personalizados no PATH
if [[ -d "$HOME/.scripts" ]]; then
  if [[ ":$PATH:" == *":$HOME/.scripts:"* ]]; then
    log_success "Scripts personalizados estão no PATH"
    
    # Contar scripts executáveis
    script_count=$(find "$HOME/.scripts" -type f -executable 2>/dev/null | wc -l)
    if [[ $script_count -gt 0 ]]; then
      log_info "Scripts executáveis encontrados: $script_count"
    else
      log_warning "Nenhum script executável encontrado em ~/.scripts"
    fi
  else
    log_warning "Scripts personalizados não estão no PATH"
  fi
fi

# Verificar configuração do WezTerm
if command -v wezterm &>/dev/null && [[ -f "$HOME/.config/wezterm/wezterm.lua" ]]; then
  if wezterm --version >/dev/null 2>&1; then
    log_success "WezTerm configurado e funcionando"
  else
    log_warning "WezTerm instalado mas pode ter problemas de configuração"
  fi
fi

# Verificar cache do Bat
if command -v bat &>/dev/null; then
  # Verificar se há temas customizados
  bat_config_dir="$HOME/.config/bat"
  if [[ -d "$bat_config_dir/themes" ]] && [[ $(ls -A "$bat_config_dir/themes" 2>/dev/null | wc -l) -gt 0 ]]; then
    log_info "Temas customizados do Bat encontrados"
  fi
  
  # Testar se bat funciona
  if echo "teste" | bat --style=plain >/dev/null 2>&1; then
    log_success "Bat funcionando corretamente"
  else
    log_warning "Bat pode ter problemas de configuração"
  fi
fi

# Verificar configuração do Mise
if command -v mise &>/dev/null && [[ -f "$HOME/.config/mise/config.toml" ]]; then
  log_success "Mise configurado"
  
  # Verificar runtimes instalados
  mise_list=$(mise list 2>/dev/null | wc -l)
  if [[ $mise_list -gt 0 ]]; then
    log_info "Runtimes do Mise instalados: $mise_list"
  else
    log_info "Nenhum runtime do Mise instalado ainda"
  fi
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

# Contar ferramentas instaladas
installed_tools=0
total_tools=${#tools[@]}

for tool in "${tools[@]}"; do
  if command -v "$tool" &>/dev/null; then
    ((installed_tools++))
  fi
done

echo "Ferramentas instaladas: $installed_tools/$total_tools"

# Status geral
if [[ $valid_symlinks -eq $total_configs ]] && [[ $installed_tools -eq $total_tools ]]; then
  log_success "Todas as configurações estão funcionando perfeitamente!"
elif [[ $valid_symlinks -eq $total_configs ]]; then
  log_warning "Configurações OK, mas algumas ferramentas não estão instaladas"
elif [[ $installed_tools -eq $total_tools ]]; then
  log_warning "Ferramentas OK, mas algumas configurações podem precisar de atenção"
else
  log_warning "Algumas configurações e ferramentas podem precisar de atenção"
fi

echo
echo "=================================="
echo "   TESTES INDIVIDUAIS"
echo "=================================="
echo "Para testar individualmente:"
echo "  fish -c 'echo Fish funcionando!'"
echo "  nvim --version"
echo "  tmux list-sessions 2>/dev/null || echo 'Nenhuma sessão tmux ativa'"
echo "  yazi --version"
echo "  lazygit --version"
echo "  mise --version"
echo "  starship --version"
echo "  wezterm --version"
echo "  bat --version"
echo "  ls ~/.scripts"
echo
echo "Testes funcionais:"
echo "  echo 'print(\"Hello World\")' | bat -l python"
echo "  starship prompt"
echo "  mise current"
echo "  yazi --help"

# Verificar se há backups anteriores
if [[ -d "$HOME/.dotfiles-backup" ]]; then
  backup_count=$(find "$HOME/.dotfiles-backup" -maxdepth 1 -type d | wc -l)
  if [[ $backup_count -gt 1 ]]; then
    echo
    log_info "Backups encontrados em ~/.dotfiles-backup/ ($((backup_count-1)) backups)"
  fi
fi
