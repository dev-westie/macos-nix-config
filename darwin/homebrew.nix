{ primaryUser, ... }:
{
  nix-homebrew = {
    enable = true;
    user = primaryUser;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };

    casks = [
      "claude"
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
      "opencode"
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
