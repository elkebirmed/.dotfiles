# Shared Home-Manager baseline: identity, font choices, session variables and
# the small set of tools every user gets.
{
  lib,
  pkgs,
  username,
  ...
}: {
  options.my.fonts = {
    sans = lib.mkOption {
      type = lib.types.str;
      default = "Noto Sans Arabic";
    };
    serif = lib.mkOption {
      type = lib.types.str;
      default = "Noto Serif Arabic";
    };
    monospace = lib.mkOption {
      type = lib.types.str;
      default = "Maple Mono NF";
    };
    ui = lib.mkOption {
      type = lib.types.str;
      default = "Rubik";
    };
  };

  config = {
    home.stateVersion = "26.05";

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "zen-beta";
      QT_QPA_PLATFORMTHEME = "gtk2";
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";
    };

    home.sessionPath = ["$HOME/.local/bin"];

    home.packages = with pkgs; [
      curl
      jq
      rsync
      tree
      unzip
      wget
      zip
    ];

    # `username` is only used to make the generated config easier to read.
    home.file.".config/dotfiles/user".text = username;
  };
}
