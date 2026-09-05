{
  pkgs,
  inputs,
  self,
  primaryUser,
  ...
}:
{
  imports = [
    ./homebrew.nix
    ./settings.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    enable = false; # using Determinate Installer
  };

  # Weekly garbage collection + store dedup, so old generations don't pile up
  # between resets even if you forget to run scripts/update. Implemented as
  # our own launchd job (not nix.gc.automatic / nix.optimise.automatic --
  # those require nix.enable = true, which we don't use since Determinate
  # manages Nix itself, not nix-darwin). This is a brief scheduled job, not
  # an always-running background process.
  launchd.daemons.nix-gc = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 14d && ${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' store optimise"
      ];
      StartCalendarInterval = [
        {
          Weekday = 0; # Sunday
          Hour = 3;
          Minute = 0;
        }
      ];
      StandardOutPath = "/var/log/nix-gc.log";
      StandardErrorPath = "/var/log/nix-gc.log";
      RunAtLoad = false;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Tells nix-darwin which account is "the" user of this machine --
  # needed for some user-scoped system settings/activation steps.
  system.primaryUser = primaryUser;

  # Declarative Homebrew management
  nix-homebrew = {
    user = primaryUser;
    enable = true;
    autoMigrate = true;
  };

  # Home Manager integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${primaryUser} = {
      imports = [
        ../home
      ];
    };
    extraSpecialArgs = {
      inherit inputs self primaryUser;
    };
  };

  # User configuration
  users.users.${primaryUser} = {
    home = "/Users/${primaryUser}";
    shell = pkgs.zsh;
  };

  environment = {
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
}
