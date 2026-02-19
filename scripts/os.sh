#!/usr/bin/env bash
set -euo pipefail

OS_NAME=""
PKG_MANAGER=""

detect_os() {
  case "$(uname -s)" in
    Darwin)
      OS_NAME="macos"
      ;;
    Linux)
      OS_NAME="linux"
      ;;
    *)
      die "Unsupported OS: $(uname -s)"
      ;;
  esac
  log "Detected OS: ${OS_NAME}"
}

detect_pkg_manager() {
  if [[ "$OS_NAME" == "macos" ]]; then
    PKG_MANAGER="brew"
    return
  fi

  if has_cmd dnf; then
    PKG_MANAGER="dnf"
  elif has_cmd apt-get; then
    PKG_MANAGER="apt"
  else
    PKG_MANAGER=""
  fi

  if [[ -n "$PKG_MANAGER" ]]; then
    log "Detected package manager: ${PKG_MANAGER}"
  else
    warn "No supported package manager detected"
  fi
}
