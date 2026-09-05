{ self, primaryUser, ... }:
{
  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # system defaults and preferences
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
      };

      finder = {
        AppleShowAllFiles = true; # show hidden files
        AppleShowAllExtensions = true; # show all file extensions
        _FXShowPosixPathInTitle = true; # show full path in title bar
        ShowPathbar = true; # breadcrumb nav at bottom
        ShowStatusBar = true; # file count & disk space
        FXPreferredViewStyle = "clmv"; # default to column view
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true; # allow quitting Finder with Cmd+Q
      };

      trackpad = {
        Clicking = true; # tap to click
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        KeyRepeat = 2; # fast key repeat rate
        InitialKeyRepeat = 15; # short delay before repeat starts
        "com.apple.trackpad.scaling" = 0.4;
        "com.apple.swipescrolldirection" = true; # natural scrolling (finger up = content scrolls down)
      };

      LaunchServices.LSQuarantine = false; # skip "downloaded from internet" warnings

      # Written directly via the raw preference domain rather than nix-darwin's
      # typed `system.defaults.SoftwareUpdate` options, since that module's
      # exposed option names shift between nix-darwin versions (AutomaticCheckEnabled
      # isn't present in the currently-pinned version, for example). Fully manual
      # macOS updates -- staying on Sequoia 15.8, no auto-check/download/install.
      CustomUserPreferences = {
        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = false;
          AutomaticDownload = false;
          AutomaticallyInstallMacOSUpdates = false;
          CriticalUpdateInstall = false;
          ConfigDataInstall = false;
        };
      };
    };
  };

  # All activation now runs as root in this nix-darwin version --
  # `postUserActivation` was removed entirely. Anything below that needs to
  # act on ${primaryUser}'s actual preferences/session (defaults write,
  # killall of a GUI app, PlistBuddy on a user plist) is explicitly run via
  # `launchctl asuser <uid> sudo -u ${primaryUser} ...`, which drops into
  # that user's real GUI session -- plain `sudo -u` from a root activation
  # script can silently fail to affect the right session.
  system.activationScripts.postActivation.text = ''
    echo "Disabling Gatekeeper..."
    spctl --master-disable || true

    if ! /usr/bin/pgrep -q oahd; then
      echo "Installing Rosetta 2..."
      softwareupdate --install-rosetta --agree-to-license
    fi

    # NOTE: Xcode Command Line Tools are installed manually after each reset --
    # run `xcode-select --install` yourself, this config doesn't automate it.

    USER_UID=$(id -u ${primaryUser})

    echo "Clearing pinned Dock items..."
    launchctl asuser "$USER_UID" sudo -u ${primaryUser} defaults write com.apple.dock persistent-apps -array
    launchctl asuser "$USER_UID" sudo -u ${primaryUser} defaults write com.apple.dock persistent-others -array
    launchctl asuser "$USER_UID" sudo -u ${primaryUser} killall Dock >/dev/null 2>&1 || true

    # Plain filesystem attribute removal -- doesn't need a user session, root can do this directly.
    echo "Removing quarantine flag from installed apps..."
    for dir in "/Applications" "/Users/${primaryUser}/Applications"; do
      if [ -d "$dir" ]; then
        xattr -dr com.apple.quarantine "$dir" 2>/dev/null || true
      fi
    done

    # Disable macOS's built-in Spotlight and screenshot keyboard shortcuts so
    # they don't conflict with Raycast's own bindings. These IDs are Apple's
    # internal "symbolic hotkey" numbers -- current as of macOS Sequoia, but
    # could shift in a future macOS version. If a shortcut doesn't get
    # disabled after a rebuild, check System Settings > Keyboard > Keyboard
    # Shortcuts to see its current state and compare against
    # `defaults read com.apple.symbolichotkeys`.
    echo "Disabling default Spotlight/screenshot shortcuts (for Raycast)..."
    PLIST="/Users/${primaryUser}/Library/Preferences/com.apple.symbolichotkeys.plist"
    for id in 64 65 28 29 30 31 32; do
      launchctl asuser "$USER_UID" sudo -u ${primaryUser} /usr/libexec/PlistBuddy \
        -c "Set :AppleSymbolicHotKeys:$id:enabled false" "$PLIST" 2>/dev/null || \
      launchctl asuser "$USER_UID" sudo -u ${primaryUser} /usr/libexec/PlistBuddy \
        -c "Add :AppleSymbolicHotKeys:$id:enabled bool false" "$PLIST" 2>/dev/null || true
    done
    launchctl asuser "$USER_UID" sudo -u ${primaryUser} killall cfprefsd >/dev/null 2>&1 || true
    launchctl asuser "$USER_UID" sudo -u ${primaryUser} killall SystemUIServer >/dev/null 2>&1 || true
  '';
}
