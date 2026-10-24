{ self, ... }:
{
  # Enable Touch ID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 6;
    configurationRevision = self.rev or self.dirtyRev or null;
    startup.chime = false;

    defaults = {
      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0; # Fixed with hyphen!
        show-recents = false;
        tilesize = 45;
        persistent-apps = [ ];
        persistent-others = [ ];
      };

      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
        ShowPathbar = true;
        FXPreferredViewStyle = "clmv";
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
      };

      NSGlobalDomain = {
        _HIHideMenuBar = true; # Auto-hide top menu bar
        NSAutomaticSpellingCorrectionEnabled = true;
        NSAutomaticCapitalizationEnabled = true;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        "com.apple.trackpad.scaling" = 0.4;
      };

      universalaccess.reduceMotion = true;
      LaunchServices.LSQuarantine = false;
    };
  };

  # Activation script (runs automatically on switch)
  system.activationScripts.postActivation.text = ''
    # Disable Gatekeeper
    if /usr/sbin/spctl --status | grep -q "assessments enabled"; then
      /usr/sbin/spctl --master-disable || true
    fi

    # Configure background security updates only (no forced OS upgrades)
    SU=/Library/Preferences/com.apple.SoftwareUpdate
    /usr/bin/defaults write "$SU" AutomaticCheckEnabled -bool true
    /usr/bin/defaults write "$SU" CriticalUpdateInstall -bool true
    /usr/bin/defaults write "$SU" ConfigDataInstall -bool true
    /usr/bin/defaults write "$SU" AutomaticallyInstallMacOSUpdates -bool false
    /usr/bin/defaults write "$SU" AutomaticDownload -bool false

    # Install Rosetta 2 on Apple Silicon Macs if missing
    if ! /usr/bin/pgrep -q oahd; then
      /usr/sbin/softwareupdate --install-rosetta --agree-to-license || true
    fi
  '';
}
