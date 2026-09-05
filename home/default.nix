{ primaryUser, ... }:
{
  imports = [
    ./packages.nix
    ./git.nix
  ];

  home = {
    username = primaryUser;
    stateVersion = "25.05";

    # Suppress the "last login" message in new terminal windows
    file.".hushlogin".text = "";
  };
}
