{ config, lib, pkgs, ... }:

{
  # Le Potato specific configurations
  networking.hostName = "lepotato";

  # Additional potato-specific packages or settings
  environment.systemPackages = with pkgs; [
    # Add any Le Potato specific packages here
    lm_sensors
    dtc  # Device Tree Compiler
  ];

  # Specific services or configurations for Le Potato
  services.le-potato-power-mgmt = {
    enable = true;
    description = "Le Potato Power Management Tweaks";
    script = ''
      # Add any specific power management or thermal throttling scripts
      echo "Applying Le Potato power management optimizations"
    '';
  };

  # Override or extend base configuration for this host
  boot = {
    # Any specific boot parameters for Le Potato
    kernelParams = [
      "console=ttyAML0,115200n8"
      "console=tty0"
    ];
  };
}
