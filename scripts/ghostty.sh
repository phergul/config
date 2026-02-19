#!/usr/bin/env bash
set -euo pipefail

ghostty_config_path() {
  if [[ "$OS_NAME" == "macos" ]]; then
    printf "%s" "${HOME}/Library/Application Support/com.mitchellh.ghostty/config"
  else
    printf "%s" "${HOME}/.config/ghostty/config"
  fi
}

install_ghostty() {
  if has_cmd ghostty; then
    log "Ghostty already installed"
  else
    if [[ "$OS_NAME" == "macos" ]]; then
      log "Installing Ghostty with brew cask"
      ensure_brew
      brew install --cask ghostty
    else
      log "Attempting Ghostty install via package manager"
      if [[ -n "$PKG_MANAGER" ]]; then
        if ! pkg_install ghostty; then
          warn "Package manager install failed; manual install needed"
        fi
      else
        warn "No package manager available; manual install needed"
      fi
    fi
  fi

  configure_ghostty_config
}

configure_ghostty_config() {
  ensure_dir "${ROOT_DIR}/templates"
  local template_path="${ROOT_DIR}/templates/ghostty.conf"
  if [[ ! -f "$template_path" ]]; then
    warn "Ghostty template missing at ${template_path}"
    return
  fi

  local dest
  dest="$(ghostty_config_path)"
  safe_link "$template_path" "$dest"
}
