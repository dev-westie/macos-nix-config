{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Dev tools
    git
    gh

    # Terminal Utilities
    curl
    neovim # provides the `nvim` binary
    tree
    # NOTE: zoxide is installed but does nothing until it's hooked into your
    # shell config (e.g. `eval "$(zoxide init zsh)"`, or home-manager's
    # `programs.zoxide.enableZshIntegration = true`). Deferred until the
    # shell/terminal rework.
    zoxide
    eza
    fd
    fzf
    ripgrep
    yazi
    bat

    # Media, Audio & Metadata Tools
    exiftool
    ffmpeg
    flac
    spicetify-cli
    yt-dlp
  ];
}
