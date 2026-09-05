# nix-config

macOS system config for `M2Mac`, using nix-darwin + home-manager + declarative Homebrew.
Single machine, single user (`westie`), rebuilt from scratch periodically.

## Stack

- **nix-darwin** — macOS system settings, defaults, activation scripts
- **home-manager** — user-level packages (git, CLI tools)
- **Homebrew** (via `nix-homebrew`) — GUI apps (casks) and a couple of CLI tools not
  cleanly packaged in nixpkgs (`mole`, `mas`)
- **nixpkgs-unstable** as the package source

Rule of thumb: CLI tools → Nix (`home/packages.nix`). GUI apps → Homebrew casks
(`darwin/homebrew.nix`). App Store apps → `darwin/homebrew.nix`'s `masApps`.

## Layout

    .
    ├── flake.nix                       # inputs + darwinConfigurations output
    ├── flake.lock
    ├── hosts/
    │   └── M2Mac/
    │       └── configuration.nix       # hostname + LocalHostName activation script
    ├── darwin/
    │   ├── default.nix                 # top-level darwin config, nix settings, GC schedule
    │   ├── settings.nix                # macOS defaults + activation scripts
    │   └── homebrew.nix                # casks + brews + masApps
    ├── home/
    │   ├── default.nix                 # home-manager entrypoint
    │   ├── git.nix
    │   └── packages.nix
    └── scripts/
        ├── bootstrap                   # first-time setup on a fresh Mac
        ├── update                      # flake update -> check -> confirm -> switch -> gc
        ├── clean                       # on-demand disk cleanup
        └── unquarantine <path>         # strip quarantine flag from one app immediately

## Everyday commands

Apply changes:

    sudo darwin-rebuild switch --flake .#M2Mac

Check before applying (won't touch the live system):

    nix flake check
    sudo darwin-rebuild check --flake .#M2Mac

Update everything (flake inputs + Homebrew), with a safety check and a
confirmation prompt before it actually applies anything:

    ./scripts/update

Free up disk space on demand:

    ./scripts/clean

Just downloaded something that says "app is damaged" or "unidentified developer"?

    ./scripts/unquarantine "/Applications/SomeApp.app"

(Everything already in `/Applications` also gets this automatically on every
rebuild — this script is only for the moment right after a fresh download,
before your next rebuild.)

Rollback:

    darwin-rebuild --list-generations
    sudo darwin-rebuild switch --rollback

## First-time setup on a freshly reset Mac

This repo is private, so the very first clone needs your own GitHub auth —
there's no way to script around that chicken-and-egg problem on a truly blank
machine (no SSH key exists yet on a fresh install).

1. Sign in to iCloud / the App Store (needed later for any `masApps`).
2. Restore your SSH key (from a password manager, iCloud Keychain, or backup)
   so you can clone a private repo.
3. Run `xcode-select --install` yourself and finish the popup. **This is not
   automated on purpose** — see "Deliberately NOT automated" below.
4. Clone this repo to `~/.config/nix`:

       git clone git@github.com:<you>/<repo>.git ~/.config/nix

5. Run the bootstrap script, which installs Nix if needed and applies the
   config for the first time:

       cd ~/.config/nix
       ./scripts/bootstrap

## Deliberately NOT automated

- **Xcode Command Line Tools** — installed by hand (`xcode-select --install`)
  every reset. A fully headless install exists as an unofficial trick but was
  intentionally left out to avoid a silent no-op if Apple changes the
  underlying package name in a future macOS release.
- **SIP (`csrutil`) changes** — Apple only allows `csrutil` to run from
  Recovery Mode, specifically so no script (including this one) can weaken
  System Integrity Protection unattended. If you ever need this again: reboot
  into Recovery (hold the power button on boot → Options), open Terminal from
  the Utilities menu, run the `csrutil` command there, reboot.
- **LibreWolf configuration** — installed as a cask, but its settings/profile
  are not managed declaratively. `programs.firefox` (pointed at the LibreWolf
  package) could do this later if wanted.
- **Shell/terminal config** — not touched at all in this config on purpose;
  being reworked separately. `zoxide` is installed but inert until a
  shell-init line is added later.

## Notes

- `nix.enable = false` — Nix itself is managed by the Determinate installer, not nix-darwin.
- Gatekeeper is fully disabled and quarantine flags are stripped from every
  app in `/Applications` and `~/Applications` on every rebuild.
- Rosetta 2 installs automatically on first rebuild (idempotent after that).
- macOS software updates are fully manual — no auto-check, auto-download, or
  auto-install. Currently pinned to Sequoia 15.8 on purpose.
- Default screenshot and Spotlight keyboard shortcuts are disabled on every
  rebuild to stay out of Raycast's way. The underlying hotkey IDs are
  Apple's undocumented internal numbering — stable for now, but worth a
  glance in System Settings → Keyboard → Keyboard Shortcuts if one doesn't
  take effect after a macOS update.
- Nix garbage collection runs automatically, weekly, deleting generations
  older than 14 days, plus store deduplication on the same schedule.
- Touch ID for sudo is enabled.

## Adding software

**GUI app** → `darwin/homebrew.nix`, add to `casks`. Find name: `brew search --cask <name>`

**App Store app** → `darwin/homebrew.nix`, add to `masApps` as `"App Name" = <id>;`.
Find ID: `mas search "app name"` (needs to be signed into the App Store app first)

**CLI tool, not in nixpkgs** → `darwin/homebrew.nix`, add to `brews`.

**CLI tool, in nixpkgs (preferred)** → `home/packages.nix`, add to `home.packages`.

## Pushing this to git

This directory isn't a git repo yet. When ready:

    cd ~/.config/nix
    git init
    git add .
    git commit -m "Initial config"
    git branch -M main
    git remote add origin git@github.com:<you>/<repo>.git
    git push -u origin main
