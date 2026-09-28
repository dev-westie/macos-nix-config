{ inputs, primaryUser, ... }:
{
  imports = [
    ./homebrew.nix
    ./settings.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  # Nix is managed by the Determinate installer, not nix-darwin.
  nix.enable = false;

  # Which account is "the" user of this machine.
  system.primaryUser = primaryUser;

  nix-homebrew = {
    enable = true;
    user = primaryUser;
    autoMigrate = true; # adopts a pre-existing Homebrew install; harmless otherwise
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup"; # existing files get renamed instead of failing
    users.${primaryUser}.imports = [ ../home ];
    extraSpecialArgs = { inherit primaryUser; };
  };

  users.users.${primaryUser}.home = "/Users/${primaryUser}";
}
