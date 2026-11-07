set shell := ["bash", "-euo", "pipefail", "-c"]

host := "MacBook"
flake := justfile_directory()

# list all recipes
default:
    @just --list --unsorted

switch:
    sudo darwin-rebuild switch --flake {{ flake }}#{{ host }}

# build only
build:
    darwin-rebuild build --flake {{ flake }}#{{ host }}
    rm -f result

# update flake inputs, build, confirm, then apply (restores flake.lock on failure/no)
update:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ flake }}"
    backup="$(mktemp)"
    cp flake.lock "$backup"
    restore() {
        cp "$backup" flake.lock
        rm -f "$backup"
        echo "flake.lock restored"
    }
    trap restore ERR
    nix flake update
    darwin-rebuild build --flake .#{{ host }}
    rm -f result
    read -r -p "Build OK. Apply now? [y/N] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        sudo darwin-rebuild switch --flake .#{{ host }}
    else
        restore
    fi
    trap - ERR
    rm -f "$backup"

brew-upgrade:
    brew upgrade
    brew upgrade --cask

generations:
    sudo darwin-rebuild --list-generations

rollback:
    sudo darwin-rebuild switch --rollback

fmt:
    nix fmt

check:
    nix flake check

changelog:
    darwin-rebuild changelog --flake {{ flake }}#{{ host }}

clean:
    sudo nix-collect-garbage --delete-older-than 7d
    nix store optimise
    brew autoremove
    brew cleanup --prune=all
