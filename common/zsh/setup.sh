#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
  pwd
)
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

install_oh_my_zsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    printf 'Oh My Zsh: already installed\n'
    return
  fi

  printf 'Oh My Zsh: installing\n'
  KEEP_ZSHRC=yes RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_plugin() {
  local name=$1
  local repository=$2
  local destination="$ZSH_CUSTOM/plugins/$name"

  if [ -d "$destination" ]; then
    printf 'Zsh plugin %s: already installed\n' "$name"
    return
  fi

  printf 'Zsh plugin %s: installing\n' "$name"
  git clone --depth=1 "$repository" "$destination"
}

copy_zshrc() {
  local target="$HOME/.zshrc"
  local source="$SCRIPT_DIR/.zshrc"
  local backup

  if [ -f "$target" ] && cmp -s "$source" "$target"; then
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup="$target.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    printf 'Moved existing %s to %s\n' "$target" "$backup"
  fi

  cp "$source" "$target"
  printf 'Copied %s to %s\n' "$source" "$target"
}

install_zshrc() {
  local response

  if [ ! -t 0 ]; then
    printf 'Zsh config: skipped because this is a non-interactive session\n'
    return
  fi

  read -r -p 'Copy .zshrc to ~/.zshrc? [Y/n] ' response || response=n
  case "$response" in
    n|N|no|NO)
      printf 'Zsh config: skipped\n'
      ;;
    *)
      copy_zshrc
      ;;
  esac
}

install_oh_my_zsh
install_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
install_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
install_zshrc
