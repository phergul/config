#!/usr/bin/env bash
set -euo pipefail

install_oh_my_zsh() {
  local omz_dir="${HOME}/.oh-my-zsh"
  if [[ -d "$omz_dir" ]]; then
    log "Oh My Zsh already installed"
    return
  fi

  log "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}
