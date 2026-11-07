{ self, ... }:
{

  networking.hostName = "MacBook";

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 7;
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
        autohide-time-modifier = 0.0;
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
        _HIHideMenuBar = true;
        NSAutomaticSpellingCorrectionEnabled = true;
        NSAutomaticCapitalizationEnabled = true;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 20;
        "com.apple.trackpad.scaling" = 0.4;
      };

      menuExtraClock = {
        FlashDateSeparators = false;
        Show24Hour = true;
        ShowAMPM = false;
        ShowSeconds = true;
        ShowDayOfWeek = true;
        ShowDayOfMonth = true;
      };

      universalaccess.reduceMotion = true;
      LaunchServices.LSQuarantine = false;
    };
  };
}
