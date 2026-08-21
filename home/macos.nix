{ ... }:
{
  xdg.configFile."ghostty/config.macos".source = ../config/ghostty/config.macos;
  xdg.configFile."aerospace".source = ../config/aerospace;
  xdg.configFile."karabiner".source = ../config/karabiner;
  xdg.configFile."starship.toml".source = ../config/starship.toml;

  home.activation.migrateLegacyMacConfigLinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for target in "$HOME/.config/aerospace" "$HOME/.config/karabiner"; do
      if [ -L "$target" ]; then
        link_target=$(readlink "$target")
        case "$link_target" in
          /nix/store/*) ;;
          *) ${../scripts/home-manager-backup} "$target" ;;
        esac
      fi
    done
  '';
}
