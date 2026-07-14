#!/usr/bin/env bash

sid="$1"
focused="${FOCUSED_WORKSPACE:-}"

if [ -z "$focused" ] && command -v aerospace >/dev/null 2>&1; then
  focused="$(aerospace list-workspaces --focused 2>/dev/null | head -n 1)"
fi

occupied=0
if command -v aerospace >/dev/null 2>&1 \
  && aerospace list-windows --workspace "$sid" 2>/dev/null | grep -q .; then
  occupied=1
fi

if [ "$sid" = "$focused" ]; then
  sketchybar --set "$NAME" \
    label="󱓻" \
    label.color=0xffffffff \
    label.font="JetBrainsMono Nerd Font:Medium:12.0"
elif [ "$occupied" -eq 1 ]; then
  sketchybar --set "$NAME" \
    label="$sid" \
    label.color=0xffc7c7c7 \
    label.font="JetBrainsMono Nerd Font:Regular:12.0"
else
  sketchybar --set "$NAME" \
    label="$sid" \
    label.color=0x80c7c7c7 \
    label.font="JetBrainsMono Nerd Font:Regular:12.0"
fi
