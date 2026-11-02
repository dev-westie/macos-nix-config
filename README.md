# nix-config

macOS system config for `MacBook` using nix-darwin + home-manager + nix-homebrew

## Stack

- **nix-darwin**
- **home-manager**
- **Nix-Homebrew**
- **nixpkgs-unstable**

## Layout

    .
    ├── flake.nix              inputs
    ├── flake.lock
    ├── Justfile               Just Comands 
    ├── darwin/
    │   ├── default.nix        Top-level darwin config, home-manager wiring
    │   ├── settings.nix       macOS defaults
    │   └── homebrew.nix       Homebrew managment 
    ├── home/
    │   ├── default.nix
    │   ├── packages.nix       Cli pkgs
    │   └── (...).nix          Other .nix configs 
    └── bootstrap              Setup Script

## Just commands

| Recipe | What it does | Manual equivalent |
|---|---|---|
| `just switch` | Apply the config | `sudo darwin-rebuild switch --flake .#MacBook` |
| `just test` | Build only. Validates without changing anything | `darwin-rebuild build --flake .#MacBook` |
| `just update` | Update inputs, build, confirm, switch. Restores `flake.lock` on failure or "no" | `nix flake update`, then build, then switch |
| `just brew-upgrade` | Upgrade Homebrew apps. The only place brew upgrades happen | `brew update && brew upgrade` |
| `just generations` | List saved system generations | `darwin-rebuild --list-generations` |
| `just rollback` | Go back one generation | `sudo darwin-rebuild switch --rollback` |
| `just fmt` | Format all `.nix` files | `nix fmt` |
| `just clean` | Full maintenance (below) | see below |

### `just clean`

    sudo nix-collect-garbage --delete-older-than 7d 
    nix-collect-garbage --delete-older-than 7d
    nix store optimise
    brew autoremove
    brew cleanup --prune=all

## First-time setup

1. Ensure fulldisk acsess is enabled for the termnial 
2. Run `xcode-select --install`
3. Clone: `git clone https://github.com/dev-westie/macos-nix-config.git ~/.config/nix`
4. Run the bootstrap script: `cd ~/.config/nix && ./scripts/bootstrap`

## Deliberate choices

- **Gatekeeper** is fully disabled system-wide. Activation runs
  `spctl --master-disable` only when it is currently enabled.
  `LSQuarantine` is also off.
- **Homebrew `cleanup = "zap"`**:
- **Homebrew upgrades are never automatic.**
- **Nix** is managed by the Determinate installer (`nix.enable = false`).
- LibreWolf settings are not managed declaratively. #Setup

## AI Note

From the commits: "Initial working config" `4f6e2b55ca7fb58a83aaf4ad891c02636f187338` to "Overhaul: settings, Justfile, README" `75b5c46d7487d3d633fea99015eed3837b80e32e` was almost entirely vibecoded with AI.
Starting with the commit "add aria2 config" `caab48319177dda07e9d8312821aa373c8ad00d8`, I will be coding things myself and only using AI to learn, help, explain things, or review/debug when I am stuck or need help.
