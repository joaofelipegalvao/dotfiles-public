#!/bin/bash

# Script de instalação de dotfiles
# Estrutura personalizada para configurações organizadas por ferramenta

set -e # Para o script se houver erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para logging
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

# Função para criar backup
create_backup() {
  local target=$1
  if [[ -e "$target" ]]; then
    local backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"

    # Preservar estrutura de diretórios no backup
    local relative_path="${target#$HOME/}"
    local backup_target="$backup_dir/$relative_path"
    mkdir -p "$(dirname "$backup_target")"

    mv "$target" "$backup_target"
    log_warning "Backup criado: $backup_target"
  fi
}

# Função para criar symlink
create_symlink() {
  local source=$1
  local target=$2

  # Criar backup se arquivo/diretório existir
  if [[ -e "$target" ]]; then
    create_backup "$target"
  fi

  # Criar diretório pai se não existir
  mkdir -p "$(dirname "$target")"

  ln -sf "$source" "$target"
  log_success "Link criado: $target -> $source"
}

# Banner
echo "=================================="
echo "   INSTALAÇÃO DE DOTFILES"
echo "   João Felipe Galvão"
echo "=================================="
echo

# Verificar se estamos no diretório correto
if [[ ! -d "$(pwd)/nvim/.config/nvim" ]] || [[ ! -d "$(pwd)/fish/.config/fish" ]]; then
  log_error "Execute este script do diretório dos dotfiles!"
  log_error "Estrutura esperada: ./nvim/.config/nvim, ./fish/.config/fish, etc."
  exit 1
fi

DOTFILES_DIR=$(pwd)
log_info "Diretório dos dotfiles: $DOTFILES_DIR"

# Configurações específicas para cada ferramenta
setup_configurations() {
  log_info "Configurando aplicações..."

  # Fish Shell
  if [[ -d "$DOTFILES_DIR/fish/.config/fish" ]]; then
    create_symlink "$DOTFILES_DIR/fish/.config/fish" "$HOME/.config/fish"
  fi

  # Neovim
  if [[ -d "$DOTFILES_DIR/nvim/.config/nvim" ]]; then
    create_symlink "$DOTFILES_DIR/nvim/.config/nvim" "$HOME/.config/nvim"
  fi

  # Tmux
  if [[ -d "$DOTFILES_DIR/tmux/.config/tmux" ]]; then
    create_symlink "$DOTFILES_DIR/tmux/.config/tmux" "$HOME/.config/tmux"
  fi

  # Yazi (file manager)
  if [[ -d "$DOTFILES_DIR/yazi/.config/yazi" ]]; then
    create_symlink "$DOTFILES_DIR/yazi/.config/yazi" "$HOME/.config/yazi"
  fi

  # Ghostty (terminal)
  if [[ -d "$DOTFILES_DIR/ghostty/.config/ghostty" ]]; then
    create_symlink "$DOTFILES_DIR/ghostty/.config/ghostty" "$HOME/.config/ghostty"
  fi

  # LazyGit
  if [[ -d "$DOTFILES_DIR/lazygit/.config/lazygit" ]]; then
    create_symlink "$DOTFILES_DIR/lazygit/.config/lazygit" "$HOME/.config/lazygit"
  fi

  # Mise (runtime manager)
  if [[ -d "$DOTFILES_DIR/mise/.config/mise" ]]; then
    create_symlink "$DOTFILES_DIR/mise/.config/mise" "$HOME/.config/mise"
  fi

  # Starship (prompt) - estrutura especial
  if [[ -f "$DOTFILES_DIR/starship/.config/starship.toml" ]]; then
    create_symlink "$DOTFILES_DIR/starship/.config/starship.toml" "$HOME/.config/starship.toml"
  fi

  # WezTerm (terminal emulator) - ADICIONADO
  if [[ -d "$DOTFILES_DIR/wezterm/.config/wezterm" ]]; then
    create_symlink "$DOTFILES_DIR/wezterm/.config/wezterm" "$HOME/.config/wezterm"
  fi

  # Bat (cat replacement) - ADICIONADO
  if [[ -d "$DOTFILES_DIR/bat/.config/bat" ]]; then
    create_symlink "$DOTFILES_DIR/bat/.config/bat" "$HOME/.config/bat"
  fi

  # Scripts personalizados - ADICIONADO
  if [[ -d "$DOTFILES_DIR/.scripts" ]]; then
    create_symlink "$DOTFILES_DIR/.scripts" "$HOME/.scripts"
    
    # Tornar scripts executáveis
    find "$DOTFILES_DIR/.scripts" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    log_success "Scripts personalizados tornados executáveis"
  fi

  # Git (arquivos na raiz)
  if [[ -f "$DOTFILES_DIR/.gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
  fi

  if [[ -f "$DOTFILES_DIR/.gitignore" ]]; then
    create_symlink "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"
  fi
}

# Executar configurações
setup_configurations

# Comandos pós-instalação
log_info "Executando comandos pós-instalação..."

# Configurar gitignore global
if [[ -f "$HOME/.gitignore" ]]; then
  git config --global core.excludesfile ~/.gitignore 2>/dev/null || true
  log_success "Gitignore global configurado"
fi

# Adicionar scripts ao PATH se existirem - ADICIONADO
if [[ -d "$HOME/.scripts" ]]; then
  # Verificar se já está no PATH
  if [[ ":$PATH:" != *":$HOME/.scripts:"* ]]; then
    log_info "Adicionando ~/.scripts ao PATH"
    echo 'export PATH="$HOME/.scripts:$PATH"' >> "$HOME/.bashrc" 2>/dev/null || true
    echo 'set -gx PATH $HOME/.scripts $PATH' >> "$HOME/.config/fish/config.fish" 2>/dev/null || true
    log_success "Scripts adicionados ao PATH"
  fi
fi

# Verificar se Fish está instalado e configurar como shell padrão
if command -v fish &>/dev/null; then
  log_info "Fish shell detectado"

  # Perguntar se quer configurar Fish como shell padrão
  read -p "Deseja configurar Fish como shell padrão? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Adicionar fish ao /etc/shells se não estiver
    if ! grep -q "$(which fish)" /etc/shells 2>/dev/null; then
      echo "$(which fish)" | sudo tee -a /etc/shells
    fi
    # Mudar shell padrão
    chsh -s "$(which fish)"
    log_success "Fish configurado como shell padrão"
  fi
else
  log_warning "Fish shell não está instalado"
fi

# Recarregar configurações do Tmux se estiver rodando
if [[ -n "$TMUX" ]]; then
  if [[ -f "$HOME/.config/tmux/tmux.conf" ]]; then
    tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null && log_success "Configuração do Tmux recarregada" || true
  elif [[ -f "$HOME/.tmux.conf" ]]; then
    tmux source-file ~/.tmux.conf 2>/dev/null && log_success "Configuração do Tmux recarregada" || true
  fi
fi

# Verificar dependências
check_dependencies() {
  log_info "Verificando dependências..."

  # Lista atualizada com WezTerm e Bat - ATUALIZADO
  local tools=("git" "fish" "nvim" "tmux" "yazi" "lazygit" "mise" "starship" "wezterm" "bat")
  local missing_tools=()

  for tool in "${tools[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
      missing_tools+=("$tool")
    fi
  done

  if [[ ${#missing_tools[@]} -gt 0 ]]; then
    log_warning "Ferramentas não instaladas: ${missing_tools[*]}"
    echo "Para instalar no Ubuntu/Debian:"
    echo "  sudo apt update"
    for tool in "${missing_tools[@]}"; do
      case "$tool" in
      "nvim") echo "  sudo apt install neovim" ;;
      "yazi") echo "  cargo install --locked yazi-fm yazi-cli" ;;
      "lazygit") echo "  sudo add-apt-repository ppa:lazygit-team/release && sudo apt install lazygit" ;;
      "mise") echo "  curl https://mise.run | sh" ;;
      "starship") echo "  curl -sS https://starship.rs/install.sh | sh" ;;
      "wezterm") echo "  # Baixar do site oficial: https://wezfurlong.org/wezterm/installation.html" ;;
      "bat") echo "  sudo apt install bat" ;;
      *) echo "  sudo apt install $tool" ;;
      esac
    done
    echo
    echo "Alternativamente, use o script de instalação de dependências se disponível:"
    echo "  ./scripts/install-dependencies.sh"
  else
    log_success "Todas as dependências estão instaladas!"
  fi
}

check_dependencies

# Configurações específicas pós-instalação - ADICIONADO
post_install_config() {
  log_info "Executando configurações específicas..."

  # Bat: criar cache de temas se estiver instalado
  if command -v bat &>/dev/null; then
    bat cache --build 2>/dev/null && log_success "Cache do Bat atualizado" || true
  fi

  # WezTerm: verificar se configuração está funcionando
  if command -v wezterm &>/dev/null && [[ -f "$HOME/.config/wezterm/wezterm.lua" ]]; then
    wezterm --version >/dev/null 2>&1 && log_success "WezTerm configurado corretamente" || log_warning "Verifique a configuração do WezTerm"
  fi

  # Mise: instalar versões de runtime se arquivo .mise.toml existir
  if command -v mise &>/dev/null && [[ -f "$DOTFILES_DIR/.mise.toml" ]]; then
    log_info "Instalando runtimes do Mise..."
    cd "$DOTFILES_DIR"
    mise install 2>/dev/null && log_success "Runtimes do Mise instalados" || log_warning "Erro ao instalar runtimes do Mise"
    cd - >/dev/null
  fi
}

post_install_config

echo
log_success "Instalação concluída!"
echo
echo "Próximos passos:"
echo "1. Reinicie seu terminal ou inicie o Fish: exec fish"
echo "2. Verifique se todas as configurações estão funcionando"
echo "3. Para Neovim, execute :checkhealth para verificar plugins"
echo "4. Configure suas chaves SSH e tokens se necessário"
echo "5. Scripts personalizados estão em ~/.scripts (se disponíveis)"
echo
echo "Para desfazer, restaure os backups em: $HOME/.dotfiles-backup/"
echo "Para reinstalar: cd $DOTFILES_DIR && ./install.sh"
