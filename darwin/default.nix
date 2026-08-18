{ ... }:
{
  system.stateVersion = 6;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  imports = [ ./homebrew.nix ];
}
