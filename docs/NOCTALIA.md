# Noctalia desktop shell

The `noctalia` role installs Noctalia and its runtime dependencies, writes a
declarative TOML configuration, and adds a Hyprland autostart hook. The Niri
configuration starts Noctalia directly. No compositor-specific settings are
managed by this role. The Noctalia config and custom palette are stored under
`~/.config/noctalia/`.

The `noctalia` role generates its Gruvbox Dark Medium palette from the shared
colors in `group_vars/all/base16.yml`. Kitty, Starship, lsd, and the greeter
configure their own settings using those same colors. To change the scheme,
edit `base16_colors` in `group_vars/all/base16.yml`.

The `noctalia_greeter` role installs Noctalia Greeter from the AUR and
configures greetd to run it as the `greeter` system account. The greeter uses
the same Base16 palette and system keyboard layout, defaults to the installed
Niri session, removes the previous SilentSDDM configuration and package,
disables SDDM when present, and enables greetd. It is ordered after the desktop
roles so the login service starts only after its session and shell are set up.

The role installs `evtest`, `python`, `hyprpicker`, and `mako`. Mako is installed
but not enabled; Noctalia provides the notification service for the session, so
running Mako alongside it could conflict.

The Bongo Cat plugin's keyboard reactivity also needs read access to the chosen
input devices. Granting the user membership in the `input` group may provide
that access, but it exposes keyboard events system-wide and is intentionally
left as a manual security decision.

The `wallpapers` role links images from `roles/wallpapers/files/wallpapers/`
into `~/Pictures/Wallpapers`, the directory configured in Noctalia. Preserve
subdirectories under the role's `files/wallpapers/` directory when adding more
wallpapers.

Noctalia plugins are pulled from their official and community Git repositories
on first launch and updated by Noctalia. The Mango layouts widget remains
configured but only provides Mango-specific controls when used with Mango.
