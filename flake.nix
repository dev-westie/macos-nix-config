{
  description = "My system configuration";

  inputs = {
    # monorepo w/ recipes ("derivations")
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # manages user-level config
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # system-level software and settings (macOS)
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # declarative homebrew management
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      ...
    }@inputs:
    let
      # change your macOS user account name here
      primaryUser = "westie";
    in
    {
      # sudo darwin-rebuild switch --flake .#MacBook   (or: just switch)
      darwinConfigurations.MacBook = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./darwin ];
        specialArgs = { inherit inputs self primaryUser; };
      };

      # makes `nix fmt` work
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
    };
}
