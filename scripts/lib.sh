#!/usr/bin/env bash
set -euo pipefail

log() {
  printf "[setup] %s\n" "$1"
}

warn() {
  printf "[setup][warn] %s\n" "$1" >&2
}

die() {
  printf "[setup][error] %s\n" "$1" >&2
  exit 1
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

ensure_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
  fi
}

safe_link() {
  local src="$1"
  local dest="$2"
  ensure_dir "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
}

download() {
  local url="$1"
  local dest="$2"
  if ! has_cmd curl; then
    die "curl is required to download $url"
  fi
  curl -fsSL "$url" -o "$dest"
}
