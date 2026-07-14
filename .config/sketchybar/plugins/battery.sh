#!/usr/bin/env bash

if [ "$SENDER" = "mouse.clicked" ]; then
  open "x-apple.systempreferences:com.apple.Battery-Settings.extension" >/dev/null 2>&1 \
    || open -a "System Settings"
fi

battery_info="$(pmset -g batt 2>/dev/null)"
line="$(printf '%s\n' "$battery_info" | tail -n 1)"
percent="$(printf '%s' "$line" | grep -Eo '[0-9]+%' | head -n 1 | tr -d '%')"
status="$(printf '%s' "$line" | awk -F';' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); print tolower($2)}')"

if [ -z "$percent" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

sketchybar --set "$NAME" drawing=on

index=$((percent / 10))
[ "$index" -gt 9 ] && index=9

charging_icons=("󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")
battery_icons=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")

if [ "$status" = "charging" ]; then
  icon="${charging_icons[$index]}"
elif [ "$status" = "charged" ]; then
  icon="󰂅"
else
  icon="${battery_icons[$index]}"
fi

if [ "$percent" -le 10 ]; then
  color=0xffa55555
elif [ "$percent" -le 20 ]; then
  color=0xffd7995b
else
  color=0xffc7c7c7
fi

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="${percent}%" label.color="$color"
