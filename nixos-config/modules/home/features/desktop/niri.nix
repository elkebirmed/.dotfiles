# Niri configuration.
#
# The compositor and session come from the NixOS module; this Home-Manager
# module owns the declarative settings. Noctalia's generated colors stay in a
# runtime-written include.
{
  config,
  lib,
  ...
}: let
  workspaceKeys = [
    {
      key = "ampersand";
      workspace = 1;
    }
    {
      key = "2";
      workspace = 2;
    }
    {
      key = "quotedbl";
      workspace = 3;
    }
    {
      key = "apostrophe";
      workspace = 4;
    }
    {
      key = "parenleft";
      workspace = 5;
    }
    {
      key = "minus";
      workspace = 6;
    }
    {
      key = "7";
      workspace = 7;
    }
    {
      key = "underscore";
      workspace = 8;
    }
    {
      key = "9";
      workspace = 9;
    }
    {
      key = "agrave";
      workspace = 10;
    }
  ];

  workspaceBinds = lib.listToAttrs (lib.concatMap (entry: [
      {
        name = "Mod+${entry.key}";
        value = {
          hotkey-overlay.title = "Focus Workspace ${toString entry.workspace}";
          action.focus-workspace = entry.workspace;
        };
      }
      {
        name = "Mod+Shift+${entry.key}";
        value = {
          hotkey-overlay.title = "Move Window to Workspace ${toString entry.workspace}";
          action.move-window-to-workspace = entry.workspace;
        };
      }
    ])
    workspaceKeys);
in {
  programs.niri.settings = {
    includes = [
      (config.lib.niri.include.optional "colors.kdl")
    ];

    input = {
      keyboard = {
        numlock = true;
        xkb = {
          layout = "fr,ara";
          options = "caps:none,grp:alt_shift_toggle";
        };
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
        accel-profile = "adaptive";
      };
      mouse.accel-profile = "adaptive";
    };

    layout = {
      gaps = 12;
      center-focused-column = "on-overflow";

      preset-column-widths = [
        {proportion = 0.33333;}
        {proportion = 0.5;}
        {proportion = 0.66667;}
      ];

      default-column-width = {proportion = 0.5;};

      focus-ring.width = 2;
      border.enable = false;

      shadow = {
        enable = true;
        softness = 12;
        spread = 0;
        offset = {
          x = 0;
          y = 5;
        };
      };
    };

    blur = {
      passes = 2;
      offset = 3.0;
      noise = 0.03;
      saturation = 1.0;
    };

    spawn-at-startup = [
      {
        argv = [
          "systemctl"
          "--user"
          "import-environment"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
        ];
      }
      {
        argv = [
          "dbus-update-activation-environment"
          "--systemd"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP=niri"
        ];
      }
      {argv = ["noctalia"];}
    ];

    hotkey-overlay.skip-at-startup = true;
    prefer-no-csd = true;

    environment.QT_QPA_PLATFORM = "wayland";
    debug.honor-xdg-activation-with-invalid-serial = [];

    binds =
      workspaceBinds
      // {
        "Mod+Return" = {
          hotkey-overlay.title = "Open Kitty Dropdown";
          action.spawn = ["kitty" "--class" "kitty-dropdown"];
        };
        "Mod+Shift+Return" = {
          hotkey-overlay.title = "Open Kitty";
          action.spawn = ["kitty"];
        };
        "Mod+Q" = {
          repeat = false;
          hotkey-overlay.title = "Close Window";
          action.close-window = [];
        };
        "ALT+F4" = {
          repeat = false;
          hotkey-overlay.title = "Close Window";
          action.close-window = [];
        };
        "Mod+Shift+E" = {
          repeat = false;
          hotkey-overlay.title = "Quit Niri";
          action.quit = [];
        };
        "Mod+Alt+L" = {
          hotkey-overlay.title = "Lock Screen";
          action.spawn = ["noctalia" "msg" "session" "lock"];
        };
        "Mod+O" = {
          repeat = false;
          hotkey-overlay.title = "Toggle overview";
          action.toggle-overview = [];
        };

        "Mod+F" = {
          hotkey-overlay.title = "Expand Column to Available Width";
          action.expand-column-to-available-width = [];
        };
        "Mod+Shift+F" = {
          hotkey-overlay.title = "Toggle Fullscreen";
          action.fullscreen-window = [];
        };
        "Mod+M" = {
          hotkey-overlay.title = "Maximize Window to Edges";
          action.maximize-window-to-edges = [];
        };
        "Mod+Shift+M" = {
          hotkey-overlay.title = "Maximize Column";
          action.maximize-column = [];
        };
        "Mod+V" = {
          hotkey-overlay.title = "Toggle Floating";
          action.toggle-window-floating = [];
        };
        "Mod+Shift+V" = {
          hotkey-overlay.title = "Switch Focus Between Floating and Tiling";
          action.switch-focus-between-floating-and-tiling = [];
        };
        "Mod+R" = {
          hotkey-overlay.title = "Switch Preset Column Width";
          action.switch-preset-column-width = [];
        };
        "Mod+Shift+R" = {
          hotkey-overlay.title = "Switch Preset Column Width Back";
          action.switch-preset-column-width-back = [];
        };
        "Mod+Ctrl+Shift+R" = {
          hotkey-overlay.title = "Switch Preset Window Height";
          action.switch-preset-window-height = [];
        };
        "Mod+Ctrl+R" = {
          hotkey-overlay.title = "Reset Window Height";
          action.reset-window-height = [];
        };
        "Mod+C" = {
          hotkey-overlay.title = "Center Column";
          action.center-column = [];
        };
        "Mod+Ctrl+C" = {
          hotkey-overlay.title = "Center Visible Columns";
          action.center-visible-columns = [];
        };
        "Mod+W" = {
          hotkey-overlay.title = "Toggle Column Tabbed Display";
          action.toggle-column-tabbed-display = [];
        };

        "Mod+Left" = {
          hotkey-overlay.title = "Focus Column Left";
          action.focus-column-left = [];
        };
        "Mod+Down" = {
          hotkey-overlay.title = "Focus Window Below";
          action.focus-window-or-workspace-down = [];
        };
        "Mod+Up" = {
          hotkey-overlay.title = "Focus Window Above";
          action.focus-window-or-workspace-up = [];
        };
        "Mod+Right" = {
          hotkey-overlay.title = "Focus Column Right";
          action.focus-column-right = [];
        };
        "Mod+H" = {
          hotkey-overlay.title = "Focus Column Left";
          action.focus-column-left = [];
        };
        "Mod+J" = {
          hotkey-overlay.title = "Focus Window Below";
          action.focus-window-or-workspace-down = [];
        };
        "Mod+K" = {
          hotkey-overlay.title = "Focus Window Above";
          action.focus-window-or-workspace-up = [];
        };
        "Mod+L" = {
          hotkey-overlay.title = "Focus Column Right";
          action.focus-column-right = [];
        };

        "Mod+Shift+Left" = {
          hotkey-overlay.title = "Move Column Left";
          action.move-column-left = [];
        };
        "Mod+Shift+Down" = {
          hotkey-overlay.title = "Move Window Down";
          action.move-window-down-or-to-workspace-down = [];
        };
        "Mod+Shift+Up" = {
          hotkey-overlay.title = "Move Window Up";
          action.move-window-up-or-to-workspace-up = [];
        };
        "Mod+Shift+Right" = {
          hotkey-overlay.title = "Move Column Right";
          action.move-column-right = [];
        };
        "Mod+Shift+H" = {
          hotkey-overlay.title = "Move Column Left";
          action.move-column-left = [];
        };
        "Mod+Shift+J" = {
          hotkey-overlay.title = "Move Window Down";
          action.move-window-down-or-to-workspace-down = [];
        };
        "Mod+Shift+K" = {
          hotkey-overlay.title = "Move Window Up";
          action.move-window-up-or-to-workspace-up = [];
        };
        "Mod+Shift+L" = {
          hotkey-overlay.title = "Move Column Right";
          action.move-column-right = [];
        };

        "Mod+Alt+Left" = {
          hotkey-overlay.title = "Decrease Column Width";
          action.set-column-width = "-10%";
        };
        "Mod+Alt+Right" = {
          hotkey-overlay.title = "Increase Column Width";
          action.set-column-width = "+10%";
        };
        "Mod+Alt+Up" = {
          hotkey-overlay.title = "Decrease Window Height";
          action.set-window-height = "-10%";
        };
        "Mod+Alt+Down" = {
          hotkey-overlay.title = "Increase Window Height";
          action.set-window-height = "+10%";
        };

        "Mod+Ctrl+Down" = {
          hotkey-overlay.title = "Focus Workspace Down";
          action.focus-workspace-down = [];
        };
        "Mod+Ctrl+Up" = {
          hotkey-overlay.title = "Focus Workspace Up";
          action.focus-workspace-up = [];
        };
        "Mod+Ctrl+Shift+Down" = {
          hotkey-overlay.title = "Move Window to Workspace Down";
          action.move-window-to-workspace-down = [];
        };
        "Mod+Ctrl+Shift+Up" = {
          hotkey-overlay.title = "Move Window to Workspace Up";
          action.move-window-to-workspace-up = [];
        };
        "MOD+Ctrl+J" = {
          hotkey-overlay.title = "Focus Workspace Down";
          action.focus-workspace-down = [];
        };
        "MOD+Ctrl+K" = {
          hotkey-overlay.title = "Focus Workspace Up";
          action.focus-workspace-up = [];
        };
        "MOD+Ctrl+Shift+J" = {
          hotkey-overlay.title = "Move Window to Workspace Down";
          action.move-window-to-workspace-down = [];
        };
        "MOD+Ctrl+Shift+K" = {
          hotkey-overlay.title = "Move Window to Workspace Up";
          action.move-window-to-workspace-up = [];
        };

        "MOD+Ctrl+Alt+Down" = {
          hotkey-overlay.title = "Move Workspace Down";
          action.move-workspace-down = [];
        };
        "MOD+Ctrl+Alt+Up" = {
          hotkey-overlay.title = "Move Workspace Up";
          action.move-workspace-up = [];
        };
        "Mod+Ctrl+Alt+J" = {
          hotkey-overlay.title = "Move Workspace Down";
          action.move-workspace-down = [];
        };
        "Mod+Ctrl+Alt+K" = {
          hotkey-overlay.title = "Move Workspace Up";
          action.move-workspace-up = [];
        };

        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          hotkey-overlay.title = "Focus Workspace Down";
          action.focus-workspace-down = [];
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          hotkey-overlay.title = "Focus Workspace Up";
          action.focus-workspace-up = [];
        };

        "Mod+Space" = {
          hotkey-overlay.title = "Open Launcher";
          action.spawn-sh = "noctalia msg panel-toggle launcher";
        };
        "Alt+Tab" = {
          hotkey-overlay.title = "Switch Windows";
          action.spawn-sh = "noctalia msg window-switcher hold";
        };
        "Mod+Tab" = {
          hotkey-overlay.title = "Focus Previous Workspace";
          action.focus-workspace-previous = [];
        };

        # Palette cycling, constrained to the current dark/light mode.
        "Mod+Shift+T" = {
          hotkey-overlay.title = "Next Theme";
          action.spawn-sh = "$HOME/.local/bin/noctalia-theme next";
        };
        "Mod+Ctrl+Shift+T" = {
          hotkey-overlay.title = "Previous Theme";
          action.spawn-sh = "$HOME/.local/bin/noctalia-theme prev";
        };
        "Mod+Alt+T" = {
          hotkey-overlay.title = "Random Theme";
          action.spawn-sh = "$HOME/.local/bin/noctalia-theme random";
        };

        # Dark / light mode.
        "Mod+Shift+Y" = {
          hotkey-overlay.title = "Toggle Dark/Light Mode";
          action.spawn-sh = "$HOME/.local/bin/noctalia-theme mode";
        };

        # Wallpaper cycling within the active palette.
        "Mod+Shift+W" = {
          hotkey-overlay.title = "Next Wallpaper";
          action.spawn-sh = "$HOME/.local/bin/noctalia-theme wallpaper-next";
        };
        "Mod+Ctrl+Shift+W" = {
          hotkey-overlay.title = "Previous Wallpaper";
          action.spawn-sh = "$HOME/.local/bin/noctalia-theme wallpaper-prev";
        };
        "Mod+Alt+W" = {
          hotkey-overlay.title = "Random Wallpaper";
          action.spawn-sh = "$HOME/.local/bin/noctalia-theme wallpaper-random";
        };

        "Print" = {
          hotkey-overlay.title = "Take Screenshot";
          action.screenshot = [];
        };
        "Ctrl+Print" = {
          hotkey-overlay.title = "Take Screenshot of Current Screen";
          action.screenshot-screen = [];
        };
        "Alt+Print" = {
          hotkey-overlay.title = "Take Screenshot of Current Window";
          action.screenshot-window = [];
        };

        "Mod+Escape" = {
          allow-inhibiting = false;
          hotkey-overlay.title = "Toggle Keyboard Shortcuts Inhibit";
          action.toggle-keyboard-shortcuts-inhibit = [];
        };

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Increase Volume";
          action.spawn-sh = "noctalia msg volume-up";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Decrease Volume";
          action.spawn-sh = "noctalia msg volume-down";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Mute Audio";
          action.spawn-sh = "noctalia msg volume-mute";
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Increase Brightness";
          action.spawn-sh = "noctalia msg brightness-up";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Decrease Brightness";
          action.spawn-sh = "noctalia msg brightness-down";
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Play/Pause";
          action.spawn = ["playerctl" "play-pause"];
        };
        "XF86AudioPause" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Play/Pause";
          action.spawn = ["playerctl" "play-pause"];
        };
        "XF86AudioStop" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Stop";
          action.spawn = ["playerctl" "stop"];
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Next Track";
          action.spawn = ["playerctl" "next"];
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          hotkey-overlay.title = "Previous Track";
          action.spawn = ["playerctl" "previous"];
        };
      };

    layer-rules = [
      {
        matches = [{namespace = "^noctalia-backdrop";}];
        place-within-backdrop = true;
      }
      {
        matches = [{namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";}];
        background-effect.xray = false;
      }
      {
        matches = [{namespace = "noctalia-window-switcher";}];
        background-effect = {
          blur = true;
          xray = false;
        };
      }
    ];

    window-rules = [
      {
        geometry-corner-radius = {
          top-left = 10.0;
          top-right = 10.0;
          bottom-right = 10.0;
          bottom-left = 10.0;
        };
        clip-to-geometry = true;
        background-effect = {
          blur = true;
          xray = false;
        };
      }
      {
        matches = [{app-id = "kitty";}];
        opacity = 0.9;
      }
      {
        matches = [{app-id = "^kitty-dropdown$";}];
        open-floating = true;
        default-column-width = {proportion = 1.0;};
        default-window-height = {proportion = 0.5;};
        focus-ring.enable = false;
        shadow.enable = false;
        geometry-corner-radius = {
          top-left = 0.0;
          top-right = 0.0;
          bottom-right = 0.0;
          bottom-left = 0.0;
        };
        default-floating-position = {
          x = 0;
          y = 0;
          relative-to = "top-left";
        };
        opacity = 0.9;
      }
      {
        matches = [{app-id = "^dev\\.noctalia\\.Noctalia$";}];
        open-floating = true;
        default-column-width = {fixed = 1080;};
        default-window-height = {fixed = 920;};
      }
      {
        matches = [
          {title = "^Picture-in-Picture$";}
          {title = "^Picture in picture$";}
          {app-id = "org.kde.kdeconnect.daemon";}
        ];
        geometry-corner-radius = {
          top-left = 24.0;
          top-right = 24.0;
          bottom-right = 24.0;
          bottom-left = 24.0;
        };
        open-floating = true;
        open-focused = false;
        default-floating-position = {
          x = 20;
          y = 20;
          relative-to = "bottom-right";
        };
        default-column-width = {proportion = 0.22;};
        default-window-height = {proportion = 0.22;};
        shadow = {
          enable = true;
          softness = 60;
          spread = 10;
          offset = {
            x = 0;
            y = 10;
          };
          draw-behind-window = true;
        };
      }
      {
        matches = [
          {title = "^save to$";}
          {title = "^Authenticate$";}
          {title = "^Library$";}
          {title = "^File Upload$";}
        ];
        open-floating = true;
        geometry-corner-radius = {
          top-left = 24.0;
          top-right = 24.0;
          bottom-right = 24.0;
          bottom-left = 24.0;
        };
        default-column-width = {fixed = 1000;};
        default-window-height = {fixed = 600;};
        shadow = {
          enable = true;
          softness = 60;
          spread = 10;
          offset = {
            x = 0;
            y = 10;
          };
          draw-behind-window = true;
        };
      }
      {
        matches = [{app-id = "yazi";}];
        open-maximized = true;
      }
      {
        matches = [
          {app-id = "bluetui";}
          {app-id = "pulsemixer";}
          {app-id = "nmtui";}
          {app-id = "dashboard";}
          {app-id = "ncdu";}
          {app-id = "battery";}
          {app-id = "sensors";}
          {app-id = "aichat";}
        ];
        open-floating = true;
        open-focused = true;
        default-floating-position = {
          x = 20;
          y = 20;
          relative-to = "bottom-right";
        };
        default-column-width = {proportion = 0.50;};
        default-window-height = {proportion = 0.55;};
        shadow = {
          enable = true;
          softness = 60;
          spread = 10;
          offset = {
            x = 0;
            y = 10;
          };
          draw-behind-window = true;
        };
      }
      {
        matches = [{app-id = "dashboard";}];
        open-floating = true;
        open-focused = true;
        default-floating-position = {
          x = 20;
          y = 20;
          relative-to = "bottom-right";
        };
        default-column-width = {proportion = 0.33;};
        default-window-height = {proportion = 0.32;};
        shadow = {
          enable = true;
          softness = 60;
          spread = 5;
          offset = {
            x = 0;
            y = 10;
          };
          draw-behind-window = true;
        };
      }
      {
        matches = [
          {
            app-id = "firefox$";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
      }
      {
        matches = [{app-id = "(?i)pavucontrol|blueman-manager|nm-connection-editor";}];
        open-floating = true;
      }
      {
        matches = [{app-id = "thunar";}];
        opacity = 0.8;
      }
    ];
  };
}
