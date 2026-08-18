{ config, lib, pkgs, zjstatus, ... }:
let
  zjstatusPackage = zjstatus.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [
    ./packages.nix
    ./zsh.nix
    ./nvim.nix
    ./git.nix
    ./terminal.nix
  ];

  xdg.enable = true;

  xdg.configFile = {
    "ghostty/config".source = ../config/ghostty/config.ghostty;
    "ghostty/themes".source = ../config/ghostty/themes;
    "zellij/config.kdl".source = ../config/zellij/config.kdl;
    "zellij/plugins/zjstatus.wasm".source = "${zjstatusPackage}/bin/zjstatus.wasm";
    # Keep Zellij's configured layout name stable while selecting the
    # platform-specific colour scheme at build time.
    "zellij/layouts/default.kdl".source =
      if pkgs.stdenv.hostPlatform.isDarwin
      then ../config/zellij/layouts/macos.kdl
      else ../config/zellij/layouts/default.kdl;
    "zellij/themes".source = ../config/zellij/themes;
  };

  # The old setup linked whole config directories. Move those legacy links out
  # of the way before Home Manager checks individual managed files.
  home.activation.migrateLegacyConfigLinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for target in \
      "$HOME/.config/nvim" \
      "$HOME/.config/zellij" \
      "$HOME/.config/ghostty"; do
      if [ -L "$target" ]; then
        link_target=$(readlink "$target")
        case "$link_target" in
          /nix/store/*)
            # Older generations managed Ghostty as one directory symlink;
            # remove only that generated link before switching to file links.
            if [ "$target" = "$HOME/.config/ghostty" ]; then
              rm -- "$target"
            fi
            ;;
          *) ${../scripts/home-manager-backup} "$target" ;;
        esac
      fi
    done
  '';

  home.activation.ensureZshLocal = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/.zshrc.local" ] && [ ! -L "$HOME/.zshrc.local" ]; then
      install -m 600 /dev/null "$HOME/.zshrc.local"
    fi
  '';

}
