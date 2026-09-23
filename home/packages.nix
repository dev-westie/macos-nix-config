{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Dev tools
    git
    gh

    # Terminal Utilities
    curl
    neovim
    tree
    zoxide
    eza
    fd
    fzf
    ripgrep
    yazi
    bat
   
    # Programming Languages & Toolchains
    python3
    uv
    nodejs
    rustc
    cargo

    # Media, Audio & Metadata Tools
    exiftool
    ffmpeg
    flac
    yt-dlp
  ];
}
