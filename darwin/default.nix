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
