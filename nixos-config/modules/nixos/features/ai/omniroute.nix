# System side of OmniRoute.
#
# The package is provided by the OmniRoute flake. The user service lives here
# so it can read the sops-rendered environment file directly.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  omniroute = inputs.omniroute.packages.${system}.default;
in {
  systemd.user.services.omniroute = {
    description = "OmniRoute AI gateway";
    after = ["network-online.target"];

    environment = {
      HOME = "%h";
      PATH = lib.mkForce (lib.makeBinPath [omniroute pkgs.nodejs_22 pkgs.coreutils]);
    };

    serviceConfig = {
      ExecStart = "${lib.getExe omniroute} serve";
      EnvironmentFile = config.sops.templates."omniroute.env".path;
      Restart = "on-failure";
      RestartSec = 5;
    };

    wantedBy = ["default.target"];
  };
}
