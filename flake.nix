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
      home-manager,
      nix-homebrew,
      ...
    }@inputs:
    let
      # change your macOS user account name here
      primaryUser = "westie";
    in
    {
      # build with:
      # $ sudo darwin-rebuild switch --flake .#M2Mac
      darwinConfigurations.M2Mac = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin
        ];
        specialArgs = {
          inherit inputs self primaryUser;
        };
      };
    };
}
