{ ... }:
{
  programs.neovim.enable = true;
  programs.neovim.withPython3 = false;
  programs.neovim.withRuby = false;
  xdg.configFile."nvim".source = ../config/nvim;
}
