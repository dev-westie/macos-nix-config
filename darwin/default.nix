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

  system.primaryUser = primaryUser;

  nix-homebrew = {
    enable = true;
    user = primaryUser;
    autoMigrate = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${primaryUser}.imports = [
      ../home
      inputs.nixvim.homeModules.nixvim
    ];
    extraSpecialArgs = { inherit primaryUser; };
  };

  users.users.${primaryUser}.home = "/Users/${primaryUser}";
}
