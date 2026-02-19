#!/usr/bin/env bash
set -euo pipefail

ensure_brew() {
  if has_cmd brew; then
    return
  fi
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

pkg_install() {
  local packages=("$@")
  case "$PKG_MANAGER" in
    brew)
      ensure_brew
      brew install "${packages[@]}"
      ;;
    dnf)
      sudo dnf install -y "${packages[@]}"
      ;;
    apt)
      sudo apt-get update -y
      sudo apt-get install -y "${packages[@]}"
      ;;
    pacman)
      sudo pacman -Sy --noconfirm "${packages[@]}"
      ;;
    zypper)
      sudo zypper install -y "${packages[@]}"
      ;;
    apk)
      sudo apk add "${packages[@]}"
      ;;
    *)
      die "No package manager available to install: ${packages[*]}"
      ;;
  esac
}

ensure_base_packages() {
  local needed=(curl git tar unzip)
  local missing=()
  local pkg
  for pkg in "${needed[@]}"; do
    if ! has_cmd "$pkg"; then
      missing+=("$pkg")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    log "Installing base packages: ${missing[*]}"
    pkg_install "${missing[@]}"
  else
    log "Base packages already installed"
  fi
}
