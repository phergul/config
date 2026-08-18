{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    fastfetch
    fzf
    gh
    git
    go
    jq
    lazydocker
    lazygit
    nodejs_22
    ripgrep
    sqlite
    tokei
    tree-sitter
    zellij
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
