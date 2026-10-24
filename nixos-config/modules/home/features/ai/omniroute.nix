# OmniRoute AI gateway.
#
# The package comes from the OmniRoute flake. The user service and its
# sops-rendered environment live in the matching NixOS feature `ai.omniroute`.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.my.ai.omniroute;
  system = pkgs.stdenv.hostPlatform.system;
  omniroute = inputs.omniroute.packages.${system}.default;
in {
  options.my.ai.omniroute = {
    enable = lib.mkEnableOption "OmniRoute AI gateway" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [omniroute];

    home.activation.omniroute = lib.hm.dag.entryAfter ["linkGeneration"] ''
      set -eu
      export PATH=${lib.makeBinPath [pkgs.coreutils]}:/run/current-system/sw/bin:$PATH

      mkdir -p "$HOME/.omniroute"
      chmod 700 "$HOME/.omniroute"

      if [ ! -r /run/secrets/OMNIROUTE_API_KEY ]; then
        echo "OmniRoute: /run/secrets/OMNIROUTE_API_KEY is missing (sops-nix)." >&2
        exit 1
      fi

      install -m 600 /run/secrets/OMNIROUTE_API_KEY "$HOME/.omniroute/api-key"
    '';
  };
}
