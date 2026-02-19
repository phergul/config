#!/usr/bin/env bash
set -euo pipefail

install_zoxide() {
  if has_cmd zoxide; then
    log "zoxide already installed"
    return
  fi

  log "Installing zoxide"
  if [[ -n "$PKG_MANAGER" ]]; then
    pkg_install zoxide
  else
    curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  fi

  local template_file="${ROOT_DIR}/templates/zoxide.zsh"
  if [[ ! -f "$template_file" ]]; then
    warn "Zoxide template missing at ${template_file}"
    return
  fi
}
