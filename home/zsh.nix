{ config, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreSpace = true;
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      nixcfg = "just --justfile ${config.home.homeDirectory}/.config/nix/Justfile";
    };
  };
}
