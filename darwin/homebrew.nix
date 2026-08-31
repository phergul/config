{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
    };
    taps = [ "nikitabobko/tap" ];
    casks = [
      "aerospace"
      "ghostty"
      "karabiner-elements"
      "linearmouse"
      "middleclick"
      "raycast"
	  "vorssaint"
    ];
  };

}
