# GTK appearance (fonts / theme) for GTK 3 and 4 applications.
{config, ...}: {
  gtk = {
    enable = true;

    font = {
      name = config.my.fonts.ui;
      size = 10;
    };

    theme = {
      name = "Adwaita";
    };

    iconTheme = {
      name = "Adwaita";
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    font-name = "${config.my.fonts.ui} 10";
    gtk-theme = "Adwaita";
    icon-theme = "Adwaita";
  };
}
