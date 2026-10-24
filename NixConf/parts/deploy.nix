# deploy-rs: push configurations to (remote) machines with automatic rollback.
#   deploy .#crazy
{
  self,
  inputs,
  lib,
  ...
}: {
  flake.deploy = {
    # SSH as root with a key (see modules/nixos/core/base.nix → PermitRootLogin).
    sshUser = "root";
    user = "root";

    # If the new generation breaks SSH/networking, deploy-rs rolls back by itself.
    magicRollback = true;
    autoRollback = true;

    # One node per nixosConfiguration, generated automatically.
    nodes =
      lib.mapAttrs (name: nixos: {
        # Replace with an IP / DNS name, or define `Host <name>` in ~/.ssh/config.
        hostname = name;

        profiles.system.path =
          inputs.deploy-rs.lib.${nixos.config.nixpkgs.hostPlatform.system}.activate.nixos nixos;
      })
      self.nixosConfigurations;
  };

  # Official deploy-rs sanity checks, exposed through `nix flake check`.
  perSystem = {system, ...}: {
    checks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
  };
}
