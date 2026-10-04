set shell := ["bash", "-euo", "pipefail", "-c"]

host := "MacBook"

# list all recipes
default:
    @just --list --unsorted

# apply the config to the live system
switch:
    sudo darwin-rebuild switch --flake .#{{ host }}

# build only: validates everything, changes nothing, needs no root
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

# upgrade Homebrew formulae and casks (the only place brew upgrades happen)
brew-upgrade:
    brew update
    brew upgrade

# list saved system generations
generations:
    darwin-rebuild --list-generations

# go back to the previous generation
rollback:
    sudo darwin-rebuild switch --rollback

# format all .nix files
fmt:
    nix fmt

# full maintenance: delete ALL old generations, dedupe store, clean Homebrew
clean:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
    nix store optimise
    brew autoremove
    brew cleanup --prune=all
