#!/usr/bin/env bash
set -euo pipefail

configure_paths() {
  local template_file="${ROOT_DIR}/templates/paths.zsh"
  if [[ ! -f "$template_file" ]]; then
    warn "Paths template missing at ${template_file}"
  fi
}
