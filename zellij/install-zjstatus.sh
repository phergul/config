#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PLUGINS_DIR="$SCRIPT_DIR/plugins"
TARGET="$PLUGINS_DIR/zjstatus.wasm"
TMP="$TARGET.tmp"
URL="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm"

mkdir -p "$PLUGINS_DIR"

if [ -f "$TARGET" ]; then
  printf 'already installed %s\n' "$TARGET"
  exit 0
fi

cleanup() {
  rm -f "$TMP"
}

trap cleanup EXIT INT TERM

if command -v curl >/dev/null 2>&1; then
  curl -fL --retry 3 --output "$TMP" "$URL"
elif command -v wget >/dev/null 2>&1; then
  wget -O "$TMP" "$URL"
else
  echo "error: need curl or wget to download zjstatus" >&2
  exit 1
fi

mv "$TMP" "$TARGET"
trap - EXIT INT TERM

printf 'installed %s\n' "$TARGET"
