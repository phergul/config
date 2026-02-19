#!/usr/bin/env bash
set -euo pipefail

install_zsh() {
  if has_cmd zsh; then
    log "zsh already installed"
  else
    log "Installing zsh"
    pkg_install zsh
  fi

  if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    if has_cmd chsh; then
      log "Setting zsh as default shell"
      chsh -s "$(command -v zsh)" || warn "Failed to change default shell"
    else
      warn "chsh not available; skipping default shell change"
    fi
  fi
}
