# GUI/terminal applications: kitty, zellij and Zen Browser.
{
  config,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      name = config.my.fonts.monospace;
      size = 11;
    };
    settings = {
      window_padding_width = 8;
      confirm_os_window_close = 0;
      background_opacity = 0.90;
      cursor_shape = "beam";
      cursor_trail = 10;
      cursor_trail_start_threshold = 0;
      cursor_trail_decay = "0.01 0.15";
    };
    extraConfig = "include ~/.config/kitty/kitty-colors.conf";
  };

  programs.zellij = {
    enable = true;
    settings.theme = "noctalia";
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  # Noctalia writes these files at runtime; make sure they exist before the
  # first theme render.
  home.activation.desktopThemeStubs = lib.hm.dag.entryAfter ["linkGeneration"] ''
    set -eu
    mkdir -p "$HOME/.config/kitty" "$HOME/.config/zellij/themes"
    [ -e "$HOME/.config/kitty/kitty-colors.conf" ] || : > "$HOME/.config/kitty/kitty-colors.conf"
    [ -e "$HOME/.config/zellij/themes/noctalia.kdl" ] || : > "$HOME/.config/zellij/themes/noctalia.kdl"
  '';
}
