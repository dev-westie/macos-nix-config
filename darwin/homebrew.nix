{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap"; # removes anything installed manually that isn't listed below
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    casks = [
      "Ghostty"
      "librewolf"
      "maccy"
      "protonvpn"
      "spotify"
      "brave-browser"
      "mullvad-browser"
      "raycast"
      "vlc"
      "whatsapp"
      "legcord"
      "gimp"
      "roblox"
      "prismlauncher"
      "shottr"
      "musicbrainz-picard"
      "free-download-manager"
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

    taps = [ ];
  };
}
