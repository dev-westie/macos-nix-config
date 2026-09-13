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
      "spotify"
      "raycast"
      "vlc"
      "whatsapp"
      "legcord"
      "roblox"
      "shottr"
      "free-download-manager"
      "crmne/tap/fastpotify"
    ];

    brews = [
      "mole"
      "mas"
    ];

    # App Store apps, installed via `mas`. Requires being signed into the
    # App Store app already -- mas can't handle Apple ID login/2FA for you.
    # Format: "App Name" = <numeric App Store ID>;
    # Find an ID with: mas search "app name"
    masApps = { };
    #ADD MAS TO HOME

    taps = [
      "crmne/tap"
    ];
  };
}
