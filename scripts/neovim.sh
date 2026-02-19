#!/usr/bin/env bash
set -euo pipefail

install_neovim() {
  if has_cmd nvim; then
    log "Neovim already installed"
    return
  fi

  if [[ "$OS_NAME" == "macos" ]]; then
    log "Installing Neovim with brew"
    pkg_install neovim
    return
  fi

  log "Installing Neovim latest release"
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local appimage_url="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
  local dest="${HOME}/.local/bin/nvim"
  ensure_dir "${HOME}/.local/bin"
  download "$appimage_url" "${tmp_dir}/nvim.appimage"
  chmod +x "${tmp_dir}/nvim.appimage"
  mv "${tmp_dir}/nvim.appimage" "$dest"
}
