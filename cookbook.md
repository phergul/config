## First-time setup

## Existing-machine migration

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

## Continuous rebuilds

Linux: `nix run home-manager -- switch --flake .#linux --impure`.

macOS: `sudo darwin-rebuild switch --flake .#macos --impure`.

If `darwin-rebuild` is not on `PATH`, use the `nix run nix-darwin` command again.

## Updating inputs and validation

Use `nix flake metadata` to inspect inputs and `nix flake update` to update all inputs. Update one input with `nix flake lock --update-input nixpkgs`, `nix flake lock --update-input home-manager`, or `nix flake lock --update-input nix-darwin`.

Review `flake.lock`, then run `nix fmt`, `nix flake check`, `nix flake show`.
