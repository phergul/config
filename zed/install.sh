#!/usr/bin/env bash
set -euo pipefail

ZED_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.config/zed"

backup_and_replace() {
  local source_file="$1"
  local target_file="$2"

  if [[ -e "$target_file" || -L "$target_file" ]]; then
    local backup_file="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$target_file" "$backup_file"
    rm -f "$target_file"
    printf "Backed up %s to %s\n" "$target_file" "$backup_file"
  fi

  cp "$source_file" "$target_file"
  printf "Installed %s\n" "$target_file"
}

mkdir -p "${TARGET_DIR}"
backup_and_replace "${ZED_DIR}/settings.json" "${TARGET_DIR}/settings.json"
backup_and_replace "${ZED_DIR}/keymap.json" "${TARGET_DIR}/keymap.json"
backup_and_replace "${ZED_DIR}/tasks.json" "${TARGET_DIR}/tasks.json"

printf "Installed Zed config from %s into %s\n" \
  "${ZED_DIR}" \
  "${TARGET_DIR}"
