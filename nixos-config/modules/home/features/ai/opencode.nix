# OpenCode, pointed at the local OmniRoute gateway.
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
  config = lib.mkIf (config.my.ai.omniroute.enable or false) {
    programs.opencode = {
      enable = true;
      mutableSettings = true;
      cli = {
        theme = {
          name = "matugen";
          mode = "system";
        };
      };
    };

    home.activation.opencode = lib.hm.dag.entryAfter ["linkGeneration" "omniroute"] ''
      set -eu
      export PATH=${lib.makeBinPath [pkgs.jq pkgs.coreutils pkgs.nodejs_22]}:/run/current-system/sw/bin:$PATH

      mkdir -p "$HOME/.config/opencode"

      key=""
      if [ -r "$HOME/.omniroute/api-key" ]; then
        key="$(cat "$HOME/.omniroute/api-key")"
      fi
      OMNIROUTE_API_KEY="$key" \
        ${lib.getExe omniroute} setup-opencode >/dev/null 2>&1 || true

      if [ -s "$HOME/.config/opencode/opencode.json" ]; then
        tmp="$(mktemp)"
        if jq 'del(.model)' "$HOME/.config/opencode/opencode.json" > "$tmp"; then
          mv "$tmp" "$HOME/.config/opencode/opencode.json"
        else
          rm -f "$tmp"
        fi
        chmod 600 "$HOME/.config/opencode/opencode.json"
      fi
    '';
  };
}
