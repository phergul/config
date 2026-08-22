## macOS without Nix

Clone this repository and run the one-time bootstrap from the checkout:

```sh
git clone git@github.com:phergul/config.git ~/config
cd ~/config
./scripts/bootstrap-macos
```

The bootstrap installs Homebrew when necessary, installs missing packages from
`Brewfile`, installs Oh My Zsh and zjstatus, and links the tracked configuration
into your home directory. Homebrew or some casks may request administrator
access during this initial setup.

The checkout remains the source of truth. Existing links update immediately
after a pull, without Nix, Homebrew, or sudo:

```sh
git pull
```

Edits made through paths such as `~/.config/nvim` or `~/.zshrc` modify files in
this checkout. Review them with `git status`, then commit and push normally.
Machine-specific shell configuration belongs in `~/.zshrc.local`, which is
created once and is never linked or overwritten.

Run the sudo-free linker again after adding a new managed path or to repair a
link:

```sh
./scripts/link-macos
```

Package changes are separate from configuration changes. Add or remove entries
in `Brewfile`, then install missing entries without upgrading existing packages:

```sh
brew bundle --file ./Brewfile --no-upgrade
```

Upgrade every package listed in the Brewfile explicitly with:

```sh
brew bundle upgrade --file ./Brewfile
```

## Nix setup

### Existing-machine migration

Linux:

```sh
nix run home-manager -- switch --flake .#linux --impure \
  -b hm-backup \
  -B "$PWD/scripts/home-manager-backup"
```

macOS:

Use the feature flags on the first switch so Nix can bootstrap nix-darwin;
they are declared permanently in `darwin/default.nix`.

```sh
sudo nix --extra-experimental-features "nix-command flakes" \
  run nix-darwin -- switch --flake .#macos --impure
```

### Continuous rebuilds

Linux: `nix run home-manager -- switch --flake .#linux --impure`.

macOS: `sudo darwin-rebuild switch --flake .#macos --impure`.

If `darwin-rebuild` is not on `PATH`, use the `nix run nix-darwin` command again.

### Updating inputs and validation

Use `nix flake metadata` to inspect inputs and `nix flake update` to update all
inputs. Update one input with `nix flake lock --update-input nixpkgs`,
`nix flake lock --update-input home-manager`, or
`nix flake lock --update-input nix-darwin`.

Review `flake.lock`, then run `nix fmt`, `nix flake check`, `nix flake show`.
