#!/usr/bin/env bash
set -euo pipefail

install_plugin() {
  local name="$1"
  local repo="$2"
  local dest="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/${name}"
  if [[ -d "$dest" ]]; then
    log "Plugin already installed: ${name}"
    return
  fi
  log "Installing plugin: ${name}"
  git clone "$repo" "$dest"
}

install_plugins() {
  install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
  install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  local template_file="${ROOT_DIR}/templates/omz-plugins.zsh"
  if [[ ! -f "$template_file" ]]; then
    warn "OMZ plugins template missing at ${template_file}"
    return
  fi
}
