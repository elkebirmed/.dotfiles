# Noctalia Greeter as the greetd login manager.
_: {
  services.displayManager.noctalia-greeter = {
    enable = true;

    settings = {
      session.default = "niri";

      appearance = {
        scheme = "Synced";
        theme_mode = "dark";
        font_family = "Rubik";
      };

      keyboard = {
        layout = "fr,ara";
        variant = "";
        options = "caps:none,grp:alt_shift_toggle";
      };
    };
  };

  # greetd's default session command comes from the greeter module.
  services.greetd.settings.default_session.user = "greeter";
}
