#!/bin/bash

# Script de desinstalação de dotfiles
# Remove symlinks e restaura backups se disponíveis

set -euo pipefail

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
echo "   DESINSTALAÇÃO DE DOTFILES"
echo "=================================="
echo

# Lista de symlinks para remover
SYMLINKS=(
  "$HOME/.config/fish"
  "$HOME/.config/nvim"
  "$HOME/.config/tmux"
  "$HOME/.config/yazi"
  "$HOME/.config/ghostty"
  "$HOME/.config/lazygit"
  "$HOME/.config/mise"
  "$HOME/.config/starship.toml"
  "$HOME/.gitconfig"
  "$HOME/.gitignore"
)

log_info "Removendo symlinks..."
echo

for symlink in "${SYMLINKS[@]}"; do
  if [[ -L "$symlink" ]]; then
    rm "$symlink"
    log_success "Removido: $symlink"
  elif [[ -e "$symlink" ]]; then
    log_warning "Existe mas não é symlink: $symlink (não removido)"
  else
    log_info "Não encontrado: $symlink"
  fi
done

echo
# Restaurar backups se disponíveis
BACKUP_DIR="$HOME/.dotfiles-backup"

if [[ -d "$BACKUP_DIR" ]]; then
  log_info "Backups encontrados em: $BACKUP_DIR"
  echo
  ls -lh "$BACKUP_DIR"
  echo
  read -rp "Deseja restaurar algum backup manualmente? (y/N): " REPLY
  echo
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    log_info "Restaure manualmente os arquivos desejados de: $BACKUP_DIR"
  else
    log_info "Backups não restaurados."
  fi
else
  log_info "Nenhum diretório de backup encontrado."
fi

echo
log_success "Desinstalação concluída!"
