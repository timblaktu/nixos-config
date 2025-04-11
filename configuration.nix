{ config, lib, pkgs, ... }:

{
  # Enable non-free packages if needed for ARM support
  nixpkgs.config.allowUnfree = true;

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Timezone and Localization
  time.timeZone = "US/Pacific";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Console configuration
  console = {
    font = "iso02-12x22";
    keyMap = "us";
  };

  # User configuration
  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
    users.tim = {
      isNormalUser = true;
      description = "Tim";
      extraGroups = [ "wheel" "networkmanager" ];
      packages = with pkgs; [
        git
        htop
        neovim
        wget
        curl
      ];
    };
  };

  # Security
  security.sudo.wheelNeedsPassword = false;

  # Packages
  environment.systemPackages = with pkgs; [
    # Add ARM-specific or Le Potato-specific packages as needed
    vim
    wget
    curl
    git
    htop
    rsync
    lm_sensors
  ];

  # Services
  services = {
    # Enable OpenSSH
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    # Optional: Configure network management
    networkmanager.enable = true;
  };

  # Programs
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    # Enable neovim as default editor
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];  # SSH
  };

  # Power Management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  # Optional: Enable zram for better memory management on low-RAM devices
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 40;  # Use up to 40% of RAM for zram
  };

  # Le Potato specific optimizations
  systemd.services.le-potato-power-mgmt = {
    description = "Le Potato Power Management Tweaks";
    wantedBy = [ "multi-user.target" ];
    script = ''
      # Add any specific power management or thermal throttling scripts here
      # For example, setting CPU frequency scaling, managing thermal zones, etc.
      echo "Applying Le Potato power management optimizations"
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
  };

  # Disable unnecessary services for a small ARM board
  services.xserver.enable = false;
  services.printing.enable = false;
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # System state version
  system.stateVersion = "24.05";
}
