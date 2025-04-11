#!/usr/bin/env bash
#
# Edit local NixOS configuration, rebuild and switch to the new environment.
#
#   - https://nixos.wiki/wiki/Flakes#Using_nix_flakes_with_NixOS

# Ensure PWD is current dir bc flake refers to files with relative paths
cd $(realpath "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)")

# Name of the nixosConfigurations element corresponding to this machine
#   - This is not necessarily the host name of this machine, however this is conventional
#   - Also the default configuration used when no name specified in --flake arg
cfgname=thinky-nixos

# nixos-rebuild Subcommand to use
#   - TODO: use boot subcmd in some cases like changing wsl.defaultUser
subcmd=switch  

# Edit configuration in vim session, and automatically rebuild/switch if user didn't :cq
nvim -S ./Session.vim && sudo nixos-rebuild "$subcmd" --flake .#"$cfgname" || echo "exit status: $?"
