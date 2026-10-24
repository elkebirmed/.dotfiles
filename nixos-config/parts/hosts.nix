# Builds `nixosConfigurations`, using haumea to discover hosts and modules from the
# filesystem so nothing needs to be listed by hand.
#
# Two kinds of modules (for both NixOS and Home-Manager):
#   core/      → loaded on EVERY host automatically
#   features/  → loaded only if a host picks them, e.g. `features.desktop.niri`
{
  self,
  inputs,
  lib,
  ...
}: let
  inherit (inputs) haumea;

  # haumea.lib.load walks a directory and returns a nested attrset mirroring it.
  # With the `path` loader every leaf is just the *path* of the .nix file (it is not
  # imported/evaluated), which is exactly what the NixOS/HM module system wants.
  #   modules/nixos/features/desktop/niri.nix → { desktop.niri = <path>; }
  loadPaths = src:
    haumea.lib.load {
      inherit src;
      loader = haumea.lib.loaders.path;
    };

  # Flatten a tree into a plain list of paths → a list of modules.
  collectModules = src: lib.collect builtins.isPath (loadPaths src);

  # Always on:
  nixosCore = collectModules ../modules/nixos/core;
  homeCore = collectModules ../modules/home/core;

  # Opt-in menus (nested attrsets of paths) handed to hosts via specialArgs:
  nixosFeatures = loadPaths ../modules/nixos/features;
  homeFeatures = loadPaths ../modules/home/features;

  # { crazy = { default = ./hosts/crazy/default.nix; hardware = ...; disko = ...; }; }
  hosts = loadPaths ../hosts;

  # Third-party NixOS modules every host needs.
  externalModules = [
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.niri.nixosModules.niri
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];

  # users/mohamed.nix, users/amine.nix, ... → { mohamed = {...}; amine = {...}; } (plain data)
  userDefs = lib.mapAttrs (_: import) (loadPaths ../users);

  mkHost = hostName: hostDir:
    inputs.nixpkgs.lib.nixosSystem {
      # Everything here becomes available as a module argument (`{inputs, userDefs, ...}:`)
      specialArgs = {
        inherit inputs self hostName userDefs homeCore homeFeatures;
        features = nixosFeatures;
      };
      modules = [hostDir.default] ++ externalModules ++ nixosCore;
    };
in {
  flake.nixosConfigurations = lib.mapAttrs mkHost hosts;
}
