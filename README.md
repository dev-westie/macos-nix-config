# nix-config

macOS system config for `MacBook` using nix-darwin + home-manager + declarative
Homebrew. Single machine, single user (`westie`), rebuilt from scratch periodically.

## Stack

- **nix-darwin**: macOS settings, defaults, activation scripts
- **home-manager**: user-level packages and git config
- **Homebrew** (via `nix-homebrew`): GUI apps (casks) and CLI tools not cleanly
  packaged in nixpkgs (`mole`)
- **nixpkgs-unstable** as the package source

Rule of thumb: CLI tools go in `home/packages.nix`. GUI apps go in
`darwin/homebrew.nix` as casks.

## Layout

    .
    ├── flake.nix              inputs, darwinConfigurations, formatter
    ├── flake.lock
    ├── Justfile               everyday commands (run `just`)
    ├── darwin/
    │   ├── default.nix        top-level darwin config, home-manager wiring
    │   ├── settings.nix       macOS defaults, Software Update, Gatekeeper, Rosetta
    │   └── homebrew.nix       casks + brews + taps
    ├── home/
    │   ├── default.nix
    │   ├── git.nix
    │   ├── packages.nix
    │   └── aria2.nix
    └── scripts/
        └── bootstrap          first-time setup on a fresh Mac

## Everyday commands

Always edit the config and run `just switch`, even for a single package. Nix only
rebuilds what changed. Installing things by hand (`brew install`, `nix profile
install`) puts software on the machine that the config does not know about, and
`zap` cleanup can later delete it. New files must be `git add`ed before building
(flakes ignore untracked files).

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

    sudo nix-collect-garbage -d     # system generations + unreferenced store paths
    nix-collect-garbage -d          # your user profiles
    nix store optimise              # deduplicate the store
    brew autoremove                 # orphaned dependencies
    brew cleanup --prune=all        # old downloads and versions

**This deletes every old generation, with no 14-day window.** After `just clean`
you can only roll back to the current generation. There is no scheduled GC in
this config, so `just clean` is the only thing that reclaims space.

## First-time setup on a freshly reset Mac

1. Run `xcode-select --install`
2. Clone: `git clone https://github.com/dev-westie/macos-nix-config.git ~/.config/nix`
3. `cd ~/.config/nix && ./scripts/bootstrap`

`just` is installed by the config, so the first apply uses the bootstrap script.

## Deliberate choices

- **Software Update** (written by an activation script into the system domain): macOS version upgrades are manual, with
  no auto-download or auto-install. Security data (XProtect, Security Responses)
  and system files install automatically. Command Line Tools updates are handled
  by hand: `softwareupdate --list`, then `sudo softwareupdate --install "<name>"`.
- **Gatekeeper** is fully disabled system-wide. Activation runs
  `spctl --master-disable` only when it is currently enabled.
  `LSQuarantine` is also off.
- **Homebrew `cleanup = "zap"`**: removing a cask also deletes its app data.
- **Homebrew upgrades are never automatic.** Use `just brew-upgrade`.
- **Keyboard shortcuts** are not managed. macOS defaults apply.
- **Nix** is managed by the Determinate installer (`nix.enable = false`).
- Rosetta 2 installs on the first rebuild (skipped if already present).
- Touch ID for sudo is enabled.
- Shell/terminal config is not managed. `zoxide`, `fzf`, `bat`, `eza` and `yazi`
  are installed but need shell init added later.
- LibreWolf settings are not managed declaratively.

## Adding software

- **GUI app**: add to `casks` in `darwin/homebrew.nix` (`brew search --cask <name>`)
- **CLI tool in nixpkgs (preferred)**: add to `home/packages.nix`
- **CLI tool not in nixpkgs**: add to `brews` in `darwin/homebrew.nix`

Then run `just switch`.

## AI Note

From the commits: "Initial working config" `4f6e2b55ca7fb58a83aaf4ad891c02636f187338` to "Overhaul: settings, Justfile, README" `75b5c46d7487d3d633fea99015eed3837b80e32e` was almost entirely vibecoded with AI.
Starting with the commit "add aria2 config" `caab48319177dda07e9d8312821aa373c8ad00d8`, I will be coding things myself and only using AI to learn, help, explain things, or review/debug when I am stuck or need help.

