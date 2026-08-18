{ ... }:
{
  programs.git.enable = true;
  programs.git.settings = {
    init.defaultBranch = "main";
    pull.rebase = false;
  };
}
