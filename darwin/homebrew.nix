{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };

    casks = [
      "ghostty"
      "maccy"
      "protonvpn"
      "raycast"
      "whatsapp"
      "legcord"
      #"roblox"
      "shottr"
      "iina"
      #"prismlauncher"
      "librewolf"
      "photocraft"
      "spotifast"
      #"keepassxc"
    ];

    brews = [
      "mole"
      #"xcodegen"
      #"ghidra"
    ];

    taps = [
      {
        name = "crmne/tap";
        trusted = true;
      }
    ];
  };
}
