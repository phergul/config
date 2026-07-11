#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
  pwd
)

"$SCRIPT_DIR/linux/setup.sh"
"$SCRIPT_DIR/common/zsh/setup.sh"

printf '\nLinux configuration setup complete. Open a new terminal to load the shell configuration.\n'
