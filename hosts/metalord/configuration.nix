{ config, lib, pkgs, ... }:

{
  # Metalord specific configurations
  networking.hostName = "metalord";

  # Any metalord-specific packages or settings
  environment.systemPackages = with pkgs; [
    # Add any Metalord specific packages here
  ];
}
