{ self, ... }:
{
  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  networking.hostName = "MacBook";

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
        show-recents = false;
        tilesize = 45;
        persistent-apps = [ ]; # nothing pinned
        persistent-others = [ ];
      };

      finder = {
        AppleShowAllFiles = true; # show hidden files
        AppleShowAllExtensions = true; # show all file extensions
        _FXShowPosixPathInTitle = true; # full path in title bar
        ShowPathbar = true; # breadcrumb nav at bottom
        FXPreferredViewStyle = "clmv"; # column view
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true; # Cmd+Q quits Finder
      };

      NSGlobalDomain = {
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        KeyRepeat = 2; # fast key repeat
        InitialKeyRepeat = 15; # short delay before repeat
        "com.apple.trackpad.scaling" = 0.4;
      };

      universalaccess = {
        reduceMotion = true;
        reduceTransparency = true;
      };

      LaunchServices.LSQuarantine = false; # skip "downloaded from internet" prompts
    };
  };

  # Activation runs as root. Both steps are idempotent.
  system.activationScripts.postActivation.text = ''
    # Gatekeeper fully disabled (system-wide). Only acts when it is enabled.
    if /usr/sbin/spctl --status | grep -q "assessments enabled"; then
      echo "Disabling Gatekeeper..."
      /usr/sbin/spctl --master-disable
    fi

    # Software Update lives in the SYSTEM domain (/Library/Preferences).
    # macOS version upgrades stay manual; security data and system files
    # install automatically. Intentional -- do not "fix".
    echo "Configuring Software Update..."
    SU=/Library/Preferences/com.apple.SoftwareUpdate
    /usr/bin/defaults write "$SU" AutomaticCheckEnabled -bool true
    /usr/bin/defaults write "$SU" CriticalUpdateInstall -bool true
    /usr/bin/defaults write "$SU" ConfigDataInstall -bool true
    /usr/bin/defaults write "$SU" AutomaticallyInstallMacOSUpdates -bool false
    /usr/bin/defaults write "$SU" AutomaticDownload -bool false

    if ! /usr/bin/pgrep -q oahd; then
      echo "Installing Rosetta 2..."
      /usr/sbin/softwareupdate --install-rosetta --agree-to-license \
        || echo "warning: Rosetta install failed (offline?), continuing"
    fi
  '';
}
