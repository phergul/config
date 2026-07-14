#!/usr/bin/env bash

# SketchyBar is launched by launchd, whose PATH does not normally include
# /usr/sbin.  Use explicit paths for macOS system utilities so this works the
# same after login as it does from an interactive terminal.
NETWORKSETUP=/usr/sbin/networksetup

if [ "$SENDER" = "mouse.clicked" ]; then
  open "x-apple.systempreferences:com.apple.wifi-settings-extension" >/dev/null 2>&1 \
    || open -a "System Settings"
fi

wifi_if="$("$NETWORKSETUP" -listallhardwareports 2>/dev/null | awk '/Hardware Port: (Wi-Fi|AirPort)/ {getline; if ($1 == "Device:") {print $2; exit}}')"

if [ -z "$wifi_if" ]; then
  sketchybar --set "$NAME" icon="󰤮" icon.color=0x80c7c7c7
  exit 0
fi

power="$("$NETWORKSETUP" -getairportpower "$wifi_if" 2>/dev/null | awk -F': ' '{print tolower($NF)}')"
ssid="$("$NETWORKSETUP" -getairportnetwork "$wifi_if" 2>/dev/null | sed -n 's/^Current Wi-Fi Network: //p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

if [ "$power" = "on" ] && [ -n "$ssid" ] \
  && ! printf '%s' "$ssid" | grep -qiE 'not associated|not connected|error'; then
  sketchybar --set "$NAME" icon="󰤨" icon.color=0xffc7c7c7
else
  sketchybar --set "$NAME" icon="󰤮" icon.color=0x80c7c7c7
fi
