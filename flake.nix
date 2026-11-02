{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      ...
    }@inputs:
    let
      # Change User Here
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
