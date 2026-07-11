#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
  pwd
)
CONFIG_ROOT=$SCRIPT_DIR/../.config

install_xcode_cli_tools() {
  if xcode-select -p >/dev/null 2>&1; then
    printf 'Xcode Command Line Tools: already installed\n'
    return
  fi

  printf 'Xcode Command Line Tools: starting installer\n'
  xcode-select --install 2>/dev/null || true
  printf 'Finish the installer dialog to continue.\n'

  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
}

install_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    printf 'Homebrew: installing\n'
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    printf 'Homebrew: already installed\n'
  fi

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    printf 'error: Homebrew was not found after installation\n' >&2
    exit 1
  fi
}

install_brewfile() {
  printf 'Homebrew packages: installing from %s/Brewfile\n' "$SCRIPT_DIR"
  brew bundle install --no-upgrade --file="$SCRIPT_DIR/Brewfile"
}

install_automator_workflow() {
  local source="$SCRIPT_DIR/services/Open Ghostty.workflow"
  local target="$HOME/Library/Services/Open Ghostty.workflow"
  local backup

  mkdir -p "$HOME/Library/Services"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup="$target.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    printf 'Moved existing Automator workflow to %s\n' "$backup"
  fi

  ln -s "$source" "$target"
  printf 'Linked %s -> %s\n' "$target" "$source"
}

configure_automator_shortcut() {
  local service='(null) - Open Ghostty - runWorkflowAsService'

  defaults write pbs NSServicesStatus -dict-add "\"$service\"" '{ key_equivalent = "@↩"; }'
  killall pbs 2>/dev/null || true
  printf 'Configured ⌘ + Return for the Open Ghostty service\n'
}

link_config_dirs() {
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

install_xcode_cli_tools
install_homebrew
install_brewfile
install_automator_workflow
configure_automator_shortcut
link_config_dirs
