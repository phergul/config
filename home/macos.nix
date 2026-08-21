{ lib, ... }:
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

  home.activation.openGhosttyService = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    service="$HOME/Library/Services/Open Ghostty.workflow"
    mkdir -p "$HOME/Library/Services"
    if [ ! -e "$service" ] && [ ! -L "$service" ]; then
      ln -s "${../macos/services}/Open Ghostty.workflow" "$service"
    fi
    defaults write pbs NSServicesStatus -dict-add "\"(null) - Open Ghostty - runWorkflowAsService\"" '{ key_equivalent = "@↩"; }'
    killall pbs 2>/dev/null || true
  '';
}
