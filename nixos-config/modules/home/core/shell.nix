# Fish shell and the command-line toolbox.
{
  config,
  lib,
  pkgs,
  ...
}: let
  fishCompletions =
    pkgs.runCommandLocal "fish-completions" {
      nativeBuildInputs = with pkgs; [
        bat
        fd
        gh
        ripgrep
        starship
      ];
    } ''
      mkdir -p $out
      bat --completion fish > $out/bat.fish
      fd --gen-completions fish > $out/fd.fish
      rg --generate complete-fish > $out/rg.fish
      starship completions fish > $out/starship.fish
      gh completion -s fish > $out/gh.fish
    '';

  bashCompletions =
    pkgs.runCommandLocal "bash-completions" {
      nativeBuildInputs = with pkgs; [
        bat
        fd
        gh
        ripgrep
        starship
      ];
    } ''
      mkdir -p $out
      bat --completion bash > $out/bat
      fd --gen-completions bash > $out/fd
      rg --generate complete-bash > $out/rg
      starship completions bash > $out/starship
      gh completion -s bash > $out/gh
    '';

  fdIgnores = lib.splitString "\n" (builtins.readFile ../files/fd/ignore);
in {
  config = {
    home.packages = with pkgs; [
      fish
      gh
      lazygit
    ];

    xdg.configFile =
      (lib.genAttrs (map (name: "fish/completions/${name}.fish") [
          "bat"
          "fd"
          "gh"
          "rg"
          "starship"
        ]) (name: {
          source = "${fishCompletions}/${name}.fish";
        }))
      // {
        "gh/config.yml".source = ../files/gh/config.yml;
      };

    xdg.dataFile =
      lib.genAttrs (map (name: "bash-completion/completions/${name}") [
        "bat"
        "fd"
        "gh"
        "rg"
        "starship"
      ]) (name: {
        source = "${bashCompletions}/${name}";
      });

    home.sessionVariables.FZF_DEFAULT_OPTS_FILE = "${config.xdg.configHome}/fzf/themes/noctalia";

    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases.grep = "grep --color=auto";
    };

    # The shell itself is set system-wide in modules/nixos/core/users.nix.
    programs.fish = {
      enable = true;
      shellAliases.cat = "bat -pP";

      interactiveShellInit = ''
        set -g fish_greeting ""

        if command -q fnm
            fnm env --use-on-cd | source
        end

        set -gx PNPM_HOME "$HOME/.local/share/pnpm"
        fish_add_path "$PNPM_HOME"

        if test -f "$HOME/.omniroute/api-key"
            set -gx OMNIROUTE_API_KEY (cat "$HOME/.omniroute/api-key")
        end
      '';

      functions = {
        "..".body = "cd ..";
        "...".body = "cd ../..";
        "....".body = "cd ../../..";
        ".....".body = "cd ../../../..";

        gh = {
          description = "Run gh with GH_TOKEN from sops-nix";
          body = ''
            set -l token_file /run/secrets/GH_TOKEN

            if not test -r $token_file
                echo "gh: $token_file is missing (sops-nix)" >&2
                return 1
            end

            set -l token (cat $token_file)
            if test -z "$token"
                echo "gh: GH_TOKEN is empty in $token_file" >&2
                return 1
            end

            set -lx GH_TOKEN "$token"
            command gh $argv
          '';
        };
      };
    };

    programs.bat = {
      enable = true;
      config = {
        style = "numbers,changes";
        italic-text = "always";
        theme = "noctalia";
      };
    };

    programs.fd = {
      enable = true;
      ignores = fdIgnores;
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.lsd = {
      enable = true;
      settings = {
        color = {
          when = "auto";
          theme = "custom";
        };
        icons = {
          when = "auto";
          theme = "fancy";
        };
        layout = "grid";
        sorting.dir-grouping = "first";
      };
    };

    programs.ripgrep = {
      enable = true;
      arguments = [
        "--ignore-file=${config.xdg.configHome}/fd/ignore"
        "--smart-case"
      ];
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
