# Pi coding agent, configured against OmniRoute.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  # Keep in sync with PORT in modules/nixos/core/secrets.nix.
  port = 20128;
in {
  config = lib.mkIf (config.my.ai.omniroute.enable or false) {
    home.packages = [inputs.pi.packages.${system}.default];

    home.file.".local/bin/pi-sync-omniroute" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        api_key_file="$HOME/.omniroute/api-key"
        [ -r "$api_key_file" ] || exit 0

        api_key="$(cat "$api_key_file")"
        [ -n "$api_key" ] || exit 0

        mkdir -p "$HOME/.pi/agent"
        tmp="$(mktemp)"
        ${pkgs.curl}/bin/curl -fsS \
          -H "Authorization: Bearer $api_key" \
          http://127.0.0.1:${toString port}/v1/models |
          ${pkgs.jq}/bin/jq --arg key "$api_key" '{
            providers: {
              omniroute: {
                baseUrl: "http://127.0.0.1:${toString port}/v1",
                api: "openai-completions",
                apiKey: $key,
                models: [.data[] | {id: .id}]
              }
            }
          }' > "$tmp"
        mv "$tmp" "$HOME/.pi/agent/models.json"
        chmod 600 "$HOME/.pi/agent/models.json"

        if [ -s "$HOME/.pi/agent/settings.json" ]; then
          tmp="$(mktemp)"
          ${pkgs.jq}/bin/jq 'del(.defaultProvider, .defaultModel)' \
            "$HOME/.pi/agent/settings.json" > "$tmp" && mv "$tmp" "$HOME/.pi/agent/settings.json"
          chmod 600 "$HOME/.pi/agent/settings.json"
        fi
      '';
    };

    home.activation.pi = lib.hm.dag.entryAfter ["linkGeneration" "omniroute"] ''
      set -eu
      export PATH=${lib.makeBinPath [pkgs.coreutils]}:/run/current-system/sw/bin:$PATH

      mkdir -p "$HOME/.pi/agent/themes"
      chmod 700 "$HOME/.pi/agent"

      if [ -x "$HOME/.local/bin/pi-sync-omniroute" ]; then
        "$HOME/.local/bin/pi-sync-omniroute" >/dev/null 2>&1 || true
      fi
    '';
  };
}
