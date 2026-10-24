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
      "iina"
      "prismlauncher"
      "netnewswire"
      "librewolf"
      "spotify"
      "tor-browser"
      "helium-browser"
      "obsidian"
      "photocraft"
      "crmne/tap/spotifast"
    ];

    brews = [
      "mole"
      #     "ghidra"
    ];

    taps = [
      {
        name = "crmne/tap";
        trusted = true;
      }
    ];
  };
}
