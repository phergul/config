#!/usr/bin/env bash

# launchd starts SketchyBar with a minimal PATH, so discover blueutil at its
# usual Homebrew locations instead of assuming an interactive-shell PATH.
blueutil=""
for candidate in /opt/homebrew/bin/blueutil /usr/local/bin/blueutil; do
  if [ -x "$candidate" ]; then
    blueutil="$candidate"
    break
  fi
done

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ] && [ -n "$blueutil" ]; then
    current="$("$blueutil" -p 2>/dev/null || echo 0)"
    if [ "$current" = "1" ]; then "$blueutil" -p 0; else "$blueutil" -p 1; fi
  else
    open "x-apple.systempreferences:com.apple.BluetoothSettings" >/dev/null 2>&1 \
      || open -a "System Settings"
  fi
fi

state="0"
if [ -n "$blueutil" ]; then
  state="$("$blueutil" -p 2>/dev/null || echo 0)"
else
  # ControllerPowerState is no longer reliably present in macOS preferences.
  # system_profiler reports the controller's current state on supported macOS
  # versions and does not depend on third-party tooling.
  if /usr/sbin/system_profiler SPBluetoothDataType 2>/dev/null | grep -qE '^[[:space:]]*State: On$'; then
    state="1"
  fi
fi

if [ "$state" = "1" ]; then
  icon=""
  color="0xffc7c7c7"
else
  icon="󰂲"
  color="0x80c7c7c7"
fi

sketchybar --set "$NAME" icon="$icon" icon.color="$color"
