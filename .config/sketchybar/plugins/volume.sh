#!/usr/bin/env bash

get_volume() {
  osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo 0
}

get_muted() {
  osascript -e 'output muted of (get volume settings)' 2>/dev/null || echo false
}

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    osascript \
      -e 'set currentSettings to get volume settings' \
      -e 'set volume output muted not (output muted of currentSettings)' \
      >/dev/null 2>&1
  else
    open "x-apple.systempreferences:com.apple.Sound-Settings.extension" >/dev/null 2>&1 \
      || open -a "System Settings"
  fi
elif [ "$SENDER" = "mouse.scrolled" ]; then
  current="$(get_volume)"
  delta="$(printf '%.0f' "${SCROLL_DELTA:-0}" 2>/dev/null || echo 0)"
  new=$((current + delta * 5))
  [ "$new" -gt 100 ] && new=100
  [ "$new" -lt 0 ] && new=0
  osascript -e "set volume output volume $new" >/dev/null 2>&1
fi

volume="$(get_volume)"
muted="$(get_muted)"

if [ "$muted" = "true" ] || [ "$volume" -eq 0 ]; then
  icon=""
elif [ "$volume" -lt 34 ]; then
  icon=""
elif [ "$volume" -lt 67 ]; then
  icon=""
else
  icon=""
fi

sketchybar --set "$NAME" icon="$icon"
