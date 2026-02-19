#!/usr/bin/env bash
set -euo pipefail

link_configs() {
  safe_link "${ROOT_DIR}/../nvim" "${HOME}/.config/nvim"
  safe_link "${ROOT_DIR}/../zellij" "${HOME}/.config/zellij"
}

configure_zshrc() {
  local zshrc="${HOME}/.zshrc"
  local marker_start="# >>> config setup >>>"
  local marker_end="# <<< config setup <<<"

  local omz_template="${ROOT_DIR}/templates/omz.zsh"
  local plugins_template="${ROOT_DIR}/templates/omz-plugins.zsh"
  local paths_template="${ROOT_DIR}/templates/paths.zsh"
  local zoxide_template="${ROOT_DIR}/templates/zoxide.zsh"
  local aliases_template="${ROOT_DIR}/templates/aliases.zsh"

  for file in "$omz_template" "$plugins_template" "$paths_template" "$zoxide_template" "$aliases_template"; do
    if [[ ! -f "$file" ]]; then
      warn "Missing template: ${file}"
      return
    fi
  done

  local include_block
  include_block=$(cat <<EOF
# >>> config setup >>>
$(cat "$omz_template")

$(cat "$plugins_template")

$(cat "$paths_template")

$(cat "$zoxide_template")

$(cat "$aliases_template")

if [ -f "${ZSH}/oh-my-zsh.sh" ]; then
  source "${ZSH}/oh-my-zsh.sh"
fi
# <<< config setup <<<
EOF
)

  if [[ -f "$zshrc" ]] && grep -qF "${marker_start}" "$zshrc"; then
    local tmp
    tmp="$(mktemp)"
    awk -v start="$marker_start" -v end="$marker_end" -v block="$include_block" '
      $0 ~ start {print block; skip=1; next}
      $0 ~ end {skip=0; next}
      !skip {print}
    ' "$zshrc" > "$tmp"
    mv "$tmp" "$zshrc"
  else
    printf "\n%s\n" "$include_block" >> "$zshrc"
  fi
}
