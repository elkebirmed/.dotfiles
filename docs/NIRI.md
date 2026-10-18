# Niri

The `niri` role installs `niri-git`, Xwayland Satellite, both GTK and GNOME
desktop portals, and the Qt 6 FFmpeg multimedia backend. The greeter defaults
to the Niri session; Hyprland remains installed and available.

Niri uses the same French/Arabic keyboard layouts, Alt+Shift layout toggle,
natural touchpad scrolling, 12-pixel gaps, rounded corners, kitty opacity,
Noctalia startup, and AZERTY workspace keys as the Hyprland setup. Directional
focus and movement, resizing, media keys, and the Noctalia launcher/settings
bindings are configured in the generated KDL file. Niri uses scrolling columns,
so Hyprland's split/swap behavior and pinned-window behavior do not have exact
equivalents. The named `scratchpad` workspace is a close substitute but does
not toggle visibility in exactly the same way as a Hyprland special workspace.
`Mod+Return` opens a floating half-height kitty window; repeated presses do not
toggle a single persistent dropdown window.

The main Niri configuration is a static file in the `niri` role. Only the
keyboard layout/options fragment is templated from Niri role defaults. It
includes `colors.kdl`, which the separate `matugen` role generates from
Noctalia's configured default wallpaper. Matugen uses its `darkness` source
color preference so wallpaper processing is deterministic when multiple
candidate colors are found. Niri reloads the configuration when any included
file changes. Changing the wallpaper in Noctalia does not automatically rerun
Matugen; reapply the playbook to regenerate the Niri colors.
