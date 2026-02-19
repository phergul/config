#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ROOT_DIR

source "${ROOT_DIR}/lib.sh"
source "${ROOT_DIR}/os.sh"
source "${ROOT_DIR}/packages.sh"
source "${ROOT_DIR}/zsh.sh"
source "${ROOT_DIR}/omz.sh"
source "${ROOT_DIR}/plugins.sh"
source "${ROOT_DIR}/paths.sh"
source "${ROOT_DIR}/aliases.sh"
source "${ROOT_DIR}/zoxide.sh"
source "${ROOT_DIR}/neovim.sh"
source "${ROOT_DIR}/zellij.sh"
source "${ROOT_DIR}/ghostty.sh"
source "${ROOT_DIR}/links.sh"

log "Starting setup"

detect_os
detect_pkg_manager
ensure_base_packages

install_zsh
install_oh_my_zsh
install_plugins
configure_paths
configure_aliases
install_zoxide
install_neovim
install_zellij
install_ghostty
link_configs
configure_zshrc

log "Setup complete"
