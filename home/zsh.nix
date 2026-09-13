{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };

    shellAliases = {
      zshsharedcfg = "nvim ~/.zshrc";
      zshcfg = "nvim ~/.zshrc.local";
      vim = "nvim";
      cd = "z";
      ls = "eza";
      lst = "eza -T -L 1";
      zellijclean = "zellij kill-all-sessions";
      ga = "git add";
      gaa = "git add .";
      gcm = "git commit -m";
      gp = "git push origin";
      gpl = "git pull";
      gk = "git checkout";
      gkb = "git checkout -b";
      gs = "git status";
      gsl = "git stash list";
      gsp = "git stash push";
      gspop = "git stash pop";
      gf = "git reflog";
    };

    initContent = ''
      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        if [ -x /opt/homebrew/bin/brew ]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      ''}

      if [ -d "$HOME/scripts" ]; then
        for file in "$HOME/scripts"/*.sh; do
          [ -r "$file" ] && source "$file"
        done
      fi

      [[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

      nix-update() {
        local config_dir="${config.home.homeDirectory}/dev/config"

        cd "$config_dir" || return
        nix flake update || return

        if [[ "$(uname -s)" == "Darwin" ]]; then
          sudo darwin-rebuild switch --flake .#macos --impure || return
        else
          nix run home-manager -- switch --flake .#linux --impure || return
        fi

        exec zsh
      }
    '';
  };

  home.sessionPath = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
    "/usr/local/sbin"
  ] ++ [
    "${config.home.homeDirectory}/.nix-profile/bin"
    "${config.home.homeDirectory}/bin"
    "${config.home.homeDirectory}/go/bin"
  ];
}
