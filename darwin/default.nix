{ ... }:
{
  system.stateVersion = 6;

  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  imports = [ ./homebrew.nix ];
}
