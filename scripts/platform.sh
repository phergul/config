# Shared by the Bash entry points. DOTFILES_OS_RELEASE allows container/test use.
detect_platform() {
    case "$(uname -s)" in
        Darwin) platform=macos ;;
        Linux)
            local release=${DOTFILES_OS_RELEASE:-/etc/os-release}
            local ID=
            [ -r "$release" ] || { printf 'Cannot read %s\n' "$release" >&2; return 1; }
            . "$release"
            [ "$ID" = arch ] || { printf 'Unsupported Linux distribution: %s (expected Arch Linux)\n' "${ID:-unknown}" >&2; return 1; }
            platform=arch
            ;;
        *) printf 'Supported platforms: macOS and Arch Linux\n' >&2; return 1 ;;
    esac
}
