# `nix develop` – everything you need to work on this repo.
{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = [
        config.treefmt.build.wrapper # `treefmt` configured with our settings
        pkgs.alejandra # Nix code formatter
        pkgs.deploy-rs # Deploy tool
        pkgs.disko # Disk partition & formating
        pkgs.nixos-anywhere # NixOS install via SSH
        pkgs.sops # Secrets management
        pkgs.age # Encryption
        pkgs.ssh-to-age # SSH to age convertion
        pkgs.nixd # Nix language server
        pkgs.git # VCS
      ];

      shellHook = ''
        echo "NixOS config dev shell – try: nix fmt | deploy .#crazy | sops secrets/secrets.yaml"
      '';
    };
  };
}
