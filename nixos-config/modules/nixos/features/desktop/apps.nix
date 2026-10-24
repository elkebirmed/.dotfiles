# Desktop integration packages. User-facing applications live in the matching
# Home-Manager features so they are only installed for users that pick them.
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    dconf
    desktop-file-utils
    gnome-themes-extra
    gtk3
    gtk4
    libnotify
    shared-mime-info
    xdg-user-dirs
    xdg-utils
  ];

  # GTK applications use the same cursor/theme as the shell.
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };
}
