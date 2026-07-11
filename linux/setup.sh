#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
  pwd
)
CONFIG_ROOT=$SCRIPT_DIR/../.config

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

install_prerequisites() {
  local missing=()
  local command_name

  for command_name in curl git zsh; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      missing+=("$command_name")
    fi
  done

  [ "${#missing[@]}" -gt 0 ] || return

  if command -v apt-get >/dev/null 2>&1; then
    run_as_root apt-get update
    run_as_root apt-get install -y "${missing[@]}"
  elif command -v dnf >/dev/null 2>&1; then
    run_as_root dnf install -y "${missing[@]}"
  elif command -v pacman >/dev/null 2>&1; then
    run_as_root pacman -S --needed "${missing[@]}"
  else
    printf 'error: missing %s and no supported package manager was found\n' "${missing[*]}" >&2
    exit 1
  fi
}

set_default_shell() {
  local zsh_path current_shell

  zsh_path=$(command -v zsh)
  current_shell=$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || true)

  if [ "$current_shell" = "$zsh_path" ]; then
    printf 'Default shell: already set to %s\n' "$zsh_path"
    return
  fi

  if ! command -v chsh >/dev/null 2>&1; then
    printf 'error: chsh is required to set Zsh as the default shell\n' >&2
    exit 1
  fi

  printf 'Default shell: changing to %s\n' "$zsh_path"
  chsh -s "$zsh_path"
}

link_config_entries() {
  local source target backup name

  mkdir -p "$HOME/.config"

  for source in "$CONFIG_ROOT"/*; do
    [ -e "$source" ] || [ -L "$source" ] || continue
    name=$(basename "$source")
    target="$HOME/.config/$name"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      continue
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
      backup="$target.backup.$(date +%Y%m%d%H%M%S)"
      mv "$target" "$backup"
      printf 'Moved existing %s to %s\n' "$target" "$backup"
    fi

    ln -s "$source" "$target"
    printf 'Linked %s -> %s\n' "$target" "$source"
  done
}

install_prerequisites
set_default_shell
link_config_entries
