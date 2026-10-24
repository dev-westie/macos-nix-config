{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Dev tools
    gh
    just

    # Terminal Utilities
    curl
    helix
    vis
    zoxide
    eza
    fd
    fzf
    ripgrep
    bat
    neovim
    tree
    #   ollama

    # Programming Languages & Toolchains
    python3
    cmake
    jdk21

    # Media, Audio & Metadata Tools
    exiftool
    ffmpeg
    yt-dlp
    aria2

    # nixpkg only apps
    ayugram-desktop
  ];
}
