{ config, ... }:
{
  programs.aria2 = {
    enable = true;

    settings = {
      dir = "${config.home.homeDirectory}/Downloads";
      continue = true;
      file-allocation = "none";

      max-connection-per-server = "16";
      split = "16";

      seed-ratio = "1.5";
    };
  };
}
