# Dotfiles

Edit the files in `config/` directly. The installed configs are symlinks to this
checkout, so edits take effect without a rebuild. Keep the checkout at its installed
location; if you move it, run `make uninstall` before moving and `make install` afterward.

## Setup

Prerequisites: Git, GNU Make, Bash, and either Homebrew on macOS or an updated Arch
Linux system with sudo. macOS's system Bash 3.2 and Make work. Install Apple's
Command Line Tools (`xcode-select --install`) for Neovim plugins that compile code.
On Arch, run `sudo pacman -Syu` before installing packages; this Makefile does not
refresh package databases or upgrade the system. `base-devel` is included for
Neovim native plugins and AUR builds.

Run these commands from the checkout:

```sh
make packages
make install
exec zsh
```

`make` alone prints help. `make install` works offline and never invokes a package
manager. Run `make packages` before using Zellij so its status plugin is available.
The installer links a directory for Neovim, individual files for Ghostty and Zellij,
and the macOS directories for AeroSpace and Karabiner. Starship config is shared
on both platforms. It selects the existing macOS/Linux Zellij layout automatically.

Zsh startup files live in `config/zsh/` and are linked into your home directory.
Keep machine-specific settings in `~/.zshrc.local`, which is loaded after the shared
aliases and integrations. Installation creates this file with mode 600 if absent
and otherwise leaves it untouched. Readable `~/scripts/*.sh` files are also sourced.
Zsh works before dependencies are installed; missing optional integrations are skipped.

On macOS the shell initializes Homebrew at `/opt/homebrew` or `/usr/local` and
adds the keg-only Node 22 binary directory to PATH. It also adds `~/bin` and
`~/go/bin` on both platforms. Changing the account's default shell is a manual
choice; the installer does not run `chsh`.

## Packages

- `packages/Brewfile` contains macOS formulae and casks. `make packages` uses
  `brew bundle`; it does not run Homebrew cleanup. Vorssaint is included on Apple
  Silicon with macOS Sonoma or later.
- `packages/arch.txt` contains official Arch packages, one per line.
- `packages/arch-aur.txt` contains optional AUR packages, one per line. It starts
  empty because the current inventory is available in official repositories.
  A nonempty list uses installed `yay`, falling back to `paru`. A missing helper
  is reported before installing packages. Helpers are never bootstrapped or run
  through sudo; ordinary package-manager review prompts remain enabled.

Both Arch lists accept blank lines and `#` comments. Arch installs use
`sudo pacman -S --needed`; Node 22 is `nodejs-lts-jod` plus `npm`. Homebrew uses
`node@22`. Package versions other than Node's major version follow the platform's
repositories. Node 22's availability depends on continued package-manager support.

After the platform packages succeed, `make packages` reuses `~/.oh-my-zsh`, or clones
[the official repository](https://github.com/ohmyzsh/ohmyzsh) there if absent. It
preserves existing installs and disables automatic Oh My Zsh updates in the shared
shell config. An existing unusable path is reported and preserved.

The same target downloads [zjstatus v0.24.0](https://github.com/dj95/zjstatus/releases/tag/v0.24.0)
into `config/zellij/plugins/zjstatus.wasm` (ignored by Git). Downloads use a temporary
file and must have a WebAssembly header before replacing the previous file.
Package commands stop at the first failure; already-installed platform packages
are not rolled back. Update the pinned version in `scripts/packages` deliberately.
Neovim continues to manage its plugins and language tools through Lazy and Mason.

## Links, backups, and custom paths

`HOME` selects the destination home directory and `XDG_CONFIG_HOME` defaults to
`~/.config`. Use absolute, normalized paths. With a custom config location, export
the same variable in the environment that launches your apps:

```sh
export XDG_CONFIG_HOME="$HOME/my-config"
make install
```

Zsh's startup files remain directly in `HOME`. The Zellij WASM and macOS Ghostty
icon use stable symlinks under `~/.local/share/zellij/plugins/` and
`~/.local/share/ghostty/`, respectively, so their plain configs work independently
of `XDG_CONFIG_HOME`.

Conflicting files, directories, and symlinks are moved beside the original path
as `.dotfiles-backup`, then `.dotfiles-backup.1`, `.dotfiles-backup.2`, and so on.
Existing backups are never overwritten. Symlinked parent directories within the
managed home/config tree are backed up before creating real parent directories;
the installer does not change their external targets. Other files inside real
Ghostty/Zellij directories are preserved. Repeating installation leaves correct
links alone. For a custom config path outside `HOME`, resolve symlinked ancestors
first: arbitrary parent symlinks outside the managed roots are rejected.

```sh
make uninstall
```

Uninstall removes only symlinks matching this checkout's expected source paths.
It skips links behind replaced parent symlinks and preserves user replacements,
backups, directories, `~/.zshrc.local`, downloaded assets, and installed packages.
It does not restore backups automatically. To restore one, uninstall first and
move the chosen backup back to its original path. Use the same `HOME` and
`XDG_CONFIG_HOME` values for installation and uninstallation.

## Migrating an existing Nix installation

Keep a terminal open during migration. Run `make packages` while Nix is still
available, then `make install`. Existing Home Manager links, including dangling
`/nix/store` links and whole config-directory links, follow the same backup rules.
Backups preserve symlinks as symlinks; restoring a store link requires its original
Nix store entry to remain available.
Check a fresh terminal, Neovim, Ghostty, and Zellij before removing Nix. Zellij
will ask for the new plugin's permissions on first use.

This repository no longer rebuilds or activates Home Manager or nix-darwin. Do
not reactivate an old generation after migration, since it may replace these links.

Machine-level removal is separate from `make uninstall`:

1. On macOS, follow [nix-darwin's uninstall instructions](https://github.com/nix-darwin/nix-darwin#uninstalling)
   while Nix still works. Do this before removing Nix itself.
2. Remove Nix using the instructions for the installer you originally used:
   [the Nix manual](https://nix.dev/manual/nix/stable/installation/uninstall) or
   [Determinate's installer](https://github.com/DeterminateSystems/nix-installer#uninstalling).
   On Linux, review any other Home Manager-managed files before deleting its profile.
3. Check system shell startup files and your local shell settings for remaining
   Nix initialization. If uninstallers restored old startup files, run `make install`
   again and verify a fresh login shell resolves tools from Homebrew or pacman.

The old nix-darwin setup enabled Touch ID for sudo. The Makefile does not manage
PAM or other system settings; review those separately if you want to keep them.

## Validation

```sh
make test
```

Tests require Python 3 and Zsh. They use disposable checkouts and homes, mock
platform/package/download commands, and do not install packages or alter your
real home directory. Native application behavior still needs a smoke check on
each platform after you choose to install the configuration.
