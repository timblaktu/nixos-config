# Hardware configuration for Libre Computer AML-S905X-CC (Le Potato)
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ARM-specific boot configuration
  boot = {
    # Use mainline Linux kernel
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Bootloader configuration for ARM
    loader = {
      # Use U-Boot as the bootloader
      generic-extlinux-compatible.enable = true;
      
      # Explicitly disable GRUB (not suitable for this ARM device)
      grub.enable = false;
    };

    # Kernel modules specific to Amlogic S905X SoC
    initrd.availableKernelModules = [
      "meson-gx-mmc"  # MMC/SD card support
      "meson-gx-usb"  # USB support
      "meson-adc"     # ADC support
    ];

    # Additional kernel modules if needed
    kernelModules = [
      "kvm-arm"       # Virtualization support
    ];

    # Device tree for Le Potato
    kernelParams = [
      "console=ttyAML0,115200n8"  # Console configuration
      "console=tty0"
    ];
  };

  # Filesystem configuration
  fileSystems = {
    "/" = {
      device = "/dev/mmcblk0p2";  # Adjust this based on your actual root partition
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };

    "/boot" = {
      device = "/dev/mmcblk0p1";  # Boot partition
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  # No swap on this device
  swapDevices = [ ];

  # Networking configuration
  networking = {
    # Enable DHCP on all interfaces
    useDHCP = lib.mkDefault true;
    
    # Specific network interface configuration might be needed
    # networking.interfaces.<interface>.useDHCP = lib.mkDefault true;
  };

  # Platform and CPU configuration
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  
  # ARM-specific CPU features
  hardware = {
    # No specific firmware needed for this device
    enableRedistributableFirmware = true;
  };

  # Power management and CPU scaling
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  # System state version (match your NixOS version)
  system.stateVersion = "24.05";
}
