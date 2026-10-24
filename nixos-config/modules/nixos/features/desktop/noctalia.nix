# System side of the Noctalia desktop shell.
# The shell itself and its configuration are installed by the Home-Manager
# feature `desktop.noctalia`.
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    evtest
    hyprpicker
    libnotify
    playerctl
    wl-clipboard
  ];

  # Integrations used by the default bar widgets.
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };
  programs.dconf.enable = true;

  # Noctalia's input-device widget (bongocat) opens /dev/input/*.
  users.groups.input = {};
}
