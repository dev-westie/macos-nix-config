set shell := ["bash", "-euo", "pipefail", "-c"]

host := "MacBook"

# list all recipes
default:
    @just --list --unsorted

switch:
    sudo darwin-rebuild switch --flake .#{{ host }}

# build only
test:
    darwin-rebuild build --flake .#{{ host }}
    rm -f result

# update flake inputs, build, confirm, then apply (restores flake.lock on failure/no)
update:
    #!/usr/bin/env bash
    set -euo pipefail
    trap 'git checkout -- flake.lock; echo "flake.lock restored"' ERR
    nix flake update
    darwin-rebuild build --flake .#{{ host }}
    rm -f result
    trap - ERR
    read -r -p "Build OK. Apply now? [y/N] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        sudo darwin-rebuild switch --flake .#{{ host }}
    else
        git checkout -- flake.lock
        echo "Skipped. flake.lock restored."
    fi

brew-upgrade:
    brew update
    brew upgrade

generations:
    darwin-rebuild --list-generations

rollback:
    sudo darwin-rebuild switch --rollback

fmt:
    nix fmt

clean:
    sudo nix-collect-garbage --delete-older-than 7d
    nix-collect-garbage --delete-older-than 7d
    nix store optimise
    brew autoremove
    brew cleanup --prune=all
