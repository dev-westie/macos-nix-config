{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    casks = [
      "Ghostty"
      "librewolf"
      "maccy"
      "protonvpn"
      "raycast"
      "whatsapp"
      "legcord"
      "roblox"
      "shottr"
      "steam"
      "IINA"
      "prismlauncher"
      "crmne/tap/spotifast"
    ];

    brews = [
      "mole"
    ];

    taps = [
      {
        name = "crmne/tap";
        trusted = true;
      }
    ];
  };
}
