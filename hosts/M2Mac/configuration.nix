{ hostname, ... }:
{
  networking.hostName = hostname;

  # Sets macOS's own "Local Hostname" (used for AirDrop, Bonjour, SSH, etc.)
  # to match, automatically on every rebuild. Saves you a manual
  # `sudo scutil --set LocalHostName ...` after a fresh macOS install/reset.
  system.activationScripts.postActivation.text = ''
    scutil --set LocalHostName "${hostname}"
  '';
}
