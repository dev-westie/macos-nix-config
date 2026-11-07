# nix-config

## Stack
- **nix-darwin**
- **home-manager**
- **Nix-Homebrew**
- **nixpkgs-unstable**

## Layout

    .
    ├── README.md
    ├── TODO.md
    ├── flake.nix
    ├── flake.lock
    ├── Justfile
    ├── bootstrap              Setup script
    ├── darwin/
    │   ├── default.nix        Module wiring
    │   ├── settings.nix       macOS defaults
    │   └── homebrew.nix       Homebrew + nix-homebrew
    └── home/
        ├── default.nix
        ├── packages.nix       CLI packages
        ├── aria2.nix
        ├── bat.nix
        ├── git.nix
        ├── nixvim.nix
        ├── zoxide.nix
        └── zsh.nix

## Just commands

| Recipe | What it does | Manual equivalent |
|---|---|---|
| `just switch` | Apply the config | `sudo darwin-rebuild switch --flake .#MacBook` |
| `just build` | Build only. Validates without changing anything | `darwin-rebuild build --flake .#MacBook` |
| `just update` | Update inputs, build, confirm, switch. Restores `flake.lock` on failure or "no" | `nix flake update`, then build, then switch |
| `just brew-upgrade` | Upgrade Homebrew formulae and casks. The only place brew upgrades happen | `brew upgrade && brew upgrade --cask` |
| `just generations` | List saved system generations | `sudo darwin-rebuild --list-generations` |
| `just rollback` | Go back one generation | `sudo darwin-rebuild switch --rollback` |
| `just fmt` | Format all `.nix` files | `nix fmt` |
| `just check` | Evaluate the flake and run checks | `nix flake check` |
| `just changelog` | Show nix-darwin release notes | `darwin-rebuild changelog --flake .#MacBook` |
| `just clean` | Full maintenance | see below |

`nixcfg` is a shell alias for `just --justfile ~/.config/nix/Justfile`, so every recipe works from any directory.

### `just clean`

    sudo nix-collect-garbage --delete-older-than 7d
    nix store optimise
    brew autoremove
    brew cleanup --prune=all

Determinate Nix already runs automatic garbage collection in the background;
this recipe only trims old system generations and Homebrew leftovers.

## First-time setup

1. Ensure Full Disk Access is enabled for the terminal.
2. Run `xcode-select --install`.
3. Clone: `git clone https://github.com/dev-westie/macos-nix-config.git ~/.config/nix`
4. Run the bootstrap script: `cd ~/.config/nix && ./bootstrap`

## Deliberate choices

- **Homebrew `cleanup = "zap"`**: activation removes any Homebrew formula or cask not listed in `darwin/homebrew.nix`, so the config is the single source of truth.
- **Homebrew upgrades are manual**: `onActivation.autoUpdate` and `upgrade` are off; use `just brew-upgrade` instead.
- **Homebrew is pinned by nix-homebrew**: `brew update` cannot update Homebrew itself because the Homebrew code lives in the Nix store.
- **Gatekeeper quarantine is off**: `LaunchServices.LSQuarantine = false` means downloaded files are not quarantined. This weakens Gatekeeper; remove the setting if you want the default protection.
- **Nix** is managed by the Determinate installer (`nix.enable = false`).
- **LibreWolf** is installed via Homebrew and its settings are not managed declaratively.

## AI Note

From the commits: "Initial working config" `4f6e2b55ca7fb58a83aaf4ad891c02636f187338` to "Overhaul: settings, Justfile, README" `75b5c46d7487d3d633fea99015eed3837b80e32e` was almost entirely vibecoded with AI.
Starting with the commit "add aria2 config" `caab48319177dda07e9d8312821aa373c8ad00d8`, I will be coding things myself and only using AI to learn, help, explain things, or review/debug when I am stuck or need help.
