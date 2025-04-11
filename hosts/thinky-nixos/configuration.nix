{ config, lib, pkgs, ... }:

{
  # Thinky WSL specific configurations
  networking.hostName = "thinky";

  # WSL-specific settings
  wsl = {
    enable = true;
    defaultUser = "tim";
    usbip.enable = true;
  };

  # Any thinky-specific packages or settings
  environment.systemPackages = with pkgs; [
    # Add any Thinky WSL specific packages here
  ];
}
