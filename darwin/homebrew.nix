{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
    };
    taps = [ "nikitabobko/tap" ];
    brews = [ "blueutil" ];
    casks = [
      "aerospace"
      "cursor"
      "ghostty"
      "karabiner-elements"
      "linearmouse"
      "middleclick"
      "raycast"
      "stats"
    ];
  };

}
