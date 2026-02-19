#!/usr/bin/env bash
set -euo pipefail

configure_aliases() {
  local template_file="${ROOT_DIR}/templates/aliases.zsh"
  if [[ ! -f "$template_file" ]]; then
    warn "Aliases template missing at ${template_file}"
  fi
}
