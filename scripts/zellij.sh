#!/usr/bin/env bash
set -euo pipefail

install_zellij() {
  if has_cmd zellij; then
    log "Zellij already installed"
    return
  fi

  if [[ "$OS_NAME" == "macos" ]]; then
    log "Installing Zellij with brew"
    pkg_install zellij
    return
  fi

  log "Installing Zellij latest release"
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local arch
  arch="$(uname -m)"
  case "$arch" in
    x86_64)
      arch="x86_64"
      ;;
    aarch64|arm64)
      arch="aarch64"
      ;;
    *)
      die "Unsupported architecture for Zellij: $arch"
      ;;
  esac

  local url="https://github.com/zellij-org/zellij/releases/latest/download/zellij-${arch}-unknown-linux-musl.tar.gz"
  local tar_path="${tmp_dir}/zellij.tar.gz"
  download "$url" "$tar_path"
  tar -xzf "$tar_path" -C "$tmp_dir"
  ensure_dir "${HOME}/.local/bin"
  mv "${tmp_dir}/zellij" "${HOME}/.local/bin/zellij"
  chmod +x "${HOME}/.local/bin/zellij"
}
