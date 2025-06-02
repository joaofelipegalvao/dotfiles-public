#!/bin/bash

# Script de desinstalação de dotfiles
# Remove symlinks e restaura backups se disponíveis

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

# Lista de symlinks para remover
SYMLINKS=(
  "$HOME/.config/fish"
  "$HOME/.config/nvim"
  "$HOME/.config/tmux"
  "$HOME/.tmux.conf"
  "$HOME/.config/yazi"
  "$HOME/.config/ghostty"
  "$HOME/.config/lazygit"
  "$HOME/.config/mise"
  "$HOME/.config/starship.toml"
  "$HOME/.gitconfig"
  "$HOME/.gitignore_global"
)

# Remover symlinks
log_info "Removendo symlinks..."
for symlink in "${SYMLINKS[@]}"; do
  if [[ -L "$symlink" ]]; then
    rm "$symlink"
    log_success "Removido: $symlink"
  elif [[ -e "$symlink" ]]; then
    log_warning "Existe mas não é symlink: $symlink"
  fi
done

# Restaurar backups se disponíveis
BACKUP_DIR="$HOME/.dotfiles-backup"
if [[ -d "$BACKUP_DIR" ]]; then
  log_info "Backups encontrados em: $BACKUP_DIR"
  echo "Backups disponíveis:"
  ls -la "$BACKUP_DIR"
  echo
  read -p "Deseja restaurar algum backup? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Restaure manualmente os arquivos desejados de: $BACKUP_DIR"
  fi
fi

log_success "Desinstalação concluída!"
