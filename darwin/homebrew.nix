{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false; # upgrades happen only via `just brew-upgrade`
      cleanup = "zap"; # intentional: removing a cask also deletes its leftover data
    };

    casks = [
      "ghostty"
      "maccy"
      "protonvpn"
      "raycast"
      "whatsapp"
      "legcord"
      "roblox"
      "shottr"
      "steam"
      "iina"
      "prismlauncher"
      "crmne/tap/spotifast"
      "netnewswire"
      "librewolf"
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
