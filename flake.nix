{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }: {
    # Host-specific hardware configurations
    nixosHardware = {
      metalord = ./hosts/metalord/hardware-configuration.nix;
      thinky = ./hosts/thinky/hardware-configuration.nix;
      potato = ./hosts/potato/hardware-configuration.nix;
    };

    nixosConfigurations = let
      mkHost = { 
        name, 
        system ? "x86_64-linux", 
        extraModules ? [], 
        isWsl ? false 
      }: 
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Conditionally import host-specific hardware config
            (self.nixosHardware.${name} or {})
            
            # Base configuration
            ./configuration.nix
            
            # Host-specific configuration
            (./hosts + "/${name}/configuration.nix")
            
            # Base host settings
            {
              networking.hostName = name;
              system.stateVersion = "24.05";
            }
            
            # WSL-specific modules
            (if isWsl then nixos-wsl.nixosModules.default else {})
          ] ++ extraModules ++ (
            if isWsl then [{
              wsl.enable = true;
              wsl.defaultUser = "tim";
              wsl.usbip.enable = true;
            }] else []
          );
        };
    in {
      metalord = mkHost { name = "metalord"; };
      "thinky-nixos" = mkHost { 
        name = "thinky"; 
        isWsl = true; 
      };
      potato = mkHost { 
        name = "potato"; 
        system = "aarch64-linux"; 
      };
    };
  };
}
