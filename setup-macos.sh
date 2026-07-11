#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
  pwd
)

"$SCRIPT_DIR/macos/setup.sh"
"$SCRIPT_DIR/common/zsh/setup.sh"

printf '\nmacOS configuration setup complete.\n'
