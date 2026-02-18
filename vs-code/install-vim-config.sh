#!/usr/bin/env bash

# If invoked via `sh`, re-exec under bash so behavior is consistent.
if [ -z "${BASH_VERSION:-}" ]; then
    exec bash "$0" "$@"
fi

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
info() { printf "%b\n" "${GREEN}[INFO]${NC} $1"; }
warn() { printf "%b\n" "${YELLOW}[WARN]${NC} $1"; }
error() { printf "%b\n" "${RED}[ERROR]${NC} $1"; }

INLINE_COMMIT_KEYS_JSON='["`","§"]'

# Detect OS and set config paths
detect_config_paths() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        VSCODE_CONFIG="$HOME/Library/Application Support/Code/User"
        CURSOR_CONFIG="$HOME/Library/Application Support/Cursor/User"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        VSCODE_CONFIG="$HOME/.config/Code/User"
        CURSOR_CONFIG="$HOME/.config/Cursor/User"
    else
        error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        error "jq is not installed. Please install it first:"
        echo "  macOS: brew install jq"
        echo "  Linux: sudo apt-get install jq or sudo yum install jq"
        exit 1
    fi
}

check_python3() {
    if ! command -v python3 &> /dev/null; then
        error "python3 is required to parse VS Code JSONC settings."
        exit 1
    fi
}

normalize_jsonc_file() {
    local source_file="$1"
    local output_file="$2"
    local expected_type="$3" # object | array

    python3 - "$source_file" "$output_file" "$expected_type" <<'PY'
import json
import sys

source_path, output_path, expected_type = sys.argv[1], sys.argv[2], sys.argv[3]
text = open(source_path, "r", encoding="utf-8").read()


def strip_jsonc_comments(value: str) -> str:
    out = []
    i = 0
    n = len(value)
    in_string = False
    quote_char = ""
    escaped = False
    in_line_comment = False
    in_block_comment = False

    while i < n:
        ch = value[i]
        nxt = value[i + 1] if i + 1 < n else ""

        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
                out.append(ch)
            i += 1
            continue

        if in_block_comment:
            if ch == "*" and nxt == "/":
                in_block_comment = False
                i += 2
                continue
            i += 1
            continue

        if in_string:
            out.append(ch)
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == quote_char:
                in_string = False
            i += 1
            continue

        if ch == '"' or ch == "'":
            in_string = True
            quote_char = ch
            out.append(ch)
            i += 1
            continue

        if ch == "/" and nxt == "/":
            in_line_comment = True
            i += 2
            continue

        if ch == "/" and nxt == "*":
            in_block_comment = True
            i += 2
            continue

        out.append(ch)
        i += 1

    return "".join(out)


def strip_trailing_commas(value: str) -> str:
    out = []
    i = 0
    n = len(value)
    in_string = False
    quote_char = ""
    escaped = False

    while i < n:
        ch = value[i]

        if in_string:
            out.append(ch)
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == quote_char:
                in_string = False
            i += 1
            continue

        if ch == '"' or ch == "'":
            in_string = True
            quote_char = ch
            out.append(ch)
            i += 1
            continue

        if ch == ",":
            j = i + 1
            while j < n and value[j] in " \t\r\n":
                j += 1
            if j < n and value[j] in "]}":
                i += 1
                continue

        out.append(ch)
        i += 1

    return "".join(out)


cleaned = strip_trailing_commas(strip_jsonc_comments(text))

try:
    parsed = json.loads(cleaned)
except json.JSONDecodeError as exc:
    print(f"Failed to parse JSON/JSONC: {source_path}", file=sys.stderr)
    print(f"Line {exc.lineno}, column {exc.colno}: {exc.msg}", file=sys.stderr)
    sys.exit(2)

if expected_type == "object" and not isinstance(parsed, dict):
    print(f"Expected JSON object in {source_path}", file=sys.stderr)
    sys.exit(3)
if expected_type == "array" and not isinstance(parsed, list):
    print(f"Expected JSON array in {source_path}", file=sys.stderr)
    sys.exit(3)

with open(output_path, "w", encoding="utf-8") as out:
    json.dump(parsed, out, ensure_ascii=False, indent=2)
    out.write("\n")
PY
}

set_inline_commit_key_mode() {
    local mode="$1"
    case "$mode" in
        both)
            INLINE_COMMIT_KEYS_JSON='["`","§"]'
            ;;
        backtick|grave|'`')
            INLINE_COMMIT_KEYS_JSON='["`"]'
            ;;
        section|'§')
            INLINE_COMMIT_KEYS_JSON='["§"]'
            ;;
        *)
            error "Invalid value for --inline-commit-key: $mode"
            echo "Valid values: both, backtick, section"
            exit 1
            ;;
    esac
}

filter_settings_inline_commit_keys() {
    local source_file="$1"
    local output_file="$2"
    jq --argjson keep_keys "$INLINE_COMMIT_KEYS_JSON" '
        def filter_bindings($keys):
            map(
                if (.before? | type == "array") and
                   (.before | length == 1) and
                   ((.before[0] == "`") or (.before[0] == "§"))
                then
                    .before[0] as $binding_key |
                    select($keys | index($binding_key))
                else
                    .
                end
            );

        ."vim.normalModeKeyBindings" = ((."vim.normalModeKeyBindings" // []) | filter_bindings($keep_keys)) |
        ."vim.insertModeKeyBindings" = ((."vim.insertModeKeyBindings" // []) | filter_bindings($keep_keys)) |
        ."vim.visualModeKeyBindings" = ((."vim.visualModeKeyBindings" // []) | filter_bindings($keep_keys))
    ' "$source_file" > "$output_file"
}

filter_keybindings_inline_commit_keys() {
    local source_file="$1"
    local output_file="$2"
    jq --argjson keep_keys "$INLINE_COMMIT_KEYS_JSON" '
        map(
            if ((.key == "`") or (.key == "§")) and
               (.command == "editor.action.inlineSuggest.commit")
            then
                .key as $binding_key |
                select($keep_keys | index($binding_key))
            else
                .
            end
        )
    ' "$source_file" > "$output_file"
}

# Function to merge JSON settings
merge_settings() {
    local source_file="$1"
    local target_file="$2"
    local backup_file="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
    local normalized_target
    local normalized_source
    
    # Create backup
    if [[ -f "$target_file" ]]; then
        info "Creating backup: $backup_file"
        cp "$target_file" "$backup_file"
    else
        info "No existing settings file, creating new one"
        echo '{}' > "$target_file"
    fi

    normalized_target="$(mktemp)"
    normalized_source="$(mktemp)"
    normalize_jsonc_file "$target_file" "$normalized_target" object
    normalize_jsonc_file "$source_file" "$normalized_source" object
    
    # Merge settings using jq
    info "Merging settings from $source_file to $target_file"
    jq -s '.[0] * .[1]' "$normalized_target" "$normalized_source" > "${target_file}.tmp"
    mv "${target_file}.tmp" "$target_file"
    rm -f "$normalized_target" "$normalized_source"
}

# Function to merge keybindings (array)
merge_keybindings() {
    local source_file="$1"
    local target_file="$2"
    local backup_file="${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
    local normalized_target
    local normalized_source
    
    # Create backup
    if [[ -f "$target_file" ]]; then
        info "Creating backup: $backup_file"
        cp "$target_file" "$backup_file"
    else
        info "No existing keybindings file, creating new one"
        echo '[]' > "$target_file"
    fi

    normalized_target="$(mktemp)"
    normalized_source="$(mktemp)"
    normalize_jsonc_file "$target_file" "$normalized_target" array
    normalize_jsonc_file "$source_file" "$normalized_source" array
    
    # Get the keybindings we want to add
    local new_keybindings
    new_keybindings=$(cat "$normalized_source")
    
    # Remove any existing conflicting keybindings and add new ones
    info "Merging keybindings from $source_file to $target_file"
    jq --argjson new "$new_keybindings" '
        # Remove existing keybindings that conflict with our new ones
        map(select(
            .key != "tab" or 
            (.command != "-editor.action.inlineSuggest.commit" and 
             .command != "selectNextSuggestion")
        )) |
        map(select(
            .key != "shift+tab" or 
            .command != "selectPrevSuggestion"
        )) |
        map(select(
            .key != "enter" or 
            (.command != "acceptSelectedSuggestion" and 
             .command != "type")
        )) |
        map(select(
            .key != "`" or 
            .command != "editor.action.inlineSuggest.commit"
        )) |
        map(select(
            .key != "§" or
            .command != "editor.action.inlineSuggest.commit"
        )) |
        # Add new keybindings
        . + $new
    ' "$normalized_target" > "${target_file}.tmp"
    mv "${target_file}.tmp" "$target_file"
    rm -f "$normalized_target" "$normalized_source"
}

# Main installation function
install_config() {
    local editor="$1"
    local config_dir="$2"
    
    info "Installing configuration for $editor"
    
    # Check if editor config directory exists
    if [[ ! -d "$config_dir" ]]; then
        warn "$editor config directory not found: $config_dir"
        warn "Skipping $editor installation"
        return
    fi
    
    # Find the source files
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local settings_source="${SETTINGS_FILE:-$script_dir/vscode-vim-settings.json}"
    local keybindings_source="${KEYBINDINGS_FILE:-$script_dir/vscode-vim-keybinds.json}"
    local filtered_settings_source
    local filtered_keybindings_source
    
    if [[ ! -f "$settings_source" ]]; then
        error "Settings file not found: $settings_source"
        exit 1
    fi
    
    if [[ ! -f "$keybindings_source" ]]; then
        error "Keybindings file not found: $keybindings_source"
        exit 1
    fi

    filtered_settings_source="$(mktemp)"
    filtered_keybindings_source="$(mktemp)"
    filter_settings_inline_commit_keys "$settings_source" "$filtered_settings_source"
    filter_keybindings_inline_commit_keys "$keybindings_source" "$filtered_keybindings_source"
    
    # Merge settings
    merge_settings "$filtered_settings_source" "$config_dir/settings.json"
    
    # Merge keybindings
    merge_keybindings "$filtered_keybindings_source" "$config_dir/keybindings.json"

    rm -f "$filtered_settings_source" "$filtered_keybindings_source"
    
    info "$editor configuration installed successfully!"
}

# Parse command line arguments
INSTALL_VSCODE=true
INSTALL_CURSOR=true
SETTINGS_FILE=""
KEYBINDINGS_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --vscode-only)
            INSTALL_CURSOR=false
            shift
            ;;
        --cursor-only)
            INSTALL_VSCODE=false
            shift
            ;;
        --settings)
            SETTINGS_FILE="$2"
            shift 2
            ;;
        --keybindings)
            KEYBINDINGS_FILE="$2"
            shift 2
            ;;
        --inline-commit-key)
            if [[ $# -lt 2 ]]; then
                error "Missing value for --inline-commit-key"
                exit 1
            fi
            set_inline_commit_key_mode "$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --vscode-only        Install only for VSCode"
            echo "  --cursor-only        Install only for Cursor"
            echo "  --settings FILE      Path to settings JSON file"
            echo "  --keybindings FILE   Path to keybindings JSON file"
            echo "  --inline-commit-key  Inline accept key: both | backtick | section"
            echo "  -h, --help          Show this help message"
            echo ""
            echo "Defaults: --inline-commit-key both"
            echo "By default, installs to both VSCode and Cursor if they exist."
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Main execution
info "Starting Vim configuration installation for VSCode/Cursor"

check_jq
check_python3
detect_config_paths

if [[ "$INSTALL_VSCODE" == true ]]; then
    install_config "VSCode" "$VSCODE_CONFIG"
fi

if [[ "$INSTALL_CURSOR" == true ]]; then
    install_config "Cursor" "$CURSOR_CONFIG"
fi

info "Installation complete!"
info "Please restart VSCode/Cursor for changes to take effect."
