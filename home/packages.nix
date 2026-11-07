{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Dev tools
    gh
    just

    # Terminal Utilities
    curl
    eza
    fd
    fzf
    ripgrep
    tree
    #ollama

    # Programming Languages & Toolchains
    python3
    cmake

    # Media, Audio & Metadata Tools
    exiftool
    ffmpeg
    yt-dlp

    # nixpkg only apps
    #ayugram-desktop
  ];
}
