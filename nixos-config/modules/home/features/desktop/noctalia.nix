# Noctalia shell, its declarative configuration and the runtime theme files
# that the shell regenerates (those must stay writable, so they are created by
# the activation script instead of being linked into the Nix store).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  noctalia = inputs.noctalia.packages.${system}.default;
  files = ../../files/noctalia;

  paletteNames = builtins.attrNames (lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".json" name)
    (builtins.readDir (files + "/palettes")));

  templateNames = builtins.attrNames (builtins.readDir (files + "/templates"));
  hookNames = builtins.attrNames (builtins.readDir (files + "/hooks"));

  wallpapers = lib.filesystem.listFilesRecursive (../../files/wallpapers);
  wallpaperRoot = toString (../../files/wallpapers);

  themeScript = "${files}/bin/noctalia-theme";

  plugins = [
    "noctalia/bongocat"
    "oldirtty/color_picker"
    "noctalia/kaomoji"
    "kenn/keybind-cheatsheet"
  ];
in {
  programs.noctalia = {
    enable = true;
    package = noctalia;

    # The existing TOML is used verbatim; runtime values live in runtime.toml.
    settings = builtins.readFile (files + "/config.toml");

    customPalettes = lib.listToAttrs (map (name: {
        name = lib.removeSuffix ".json" name;
        value = files + "/palettes/${name}";
      })
      paletteNames);
  };

  xdg.configFile =
    (lib.listToAttrs (map (name: {
        name = "noctalia/templates/${name}";
        value.source = files + "/templates/${name}";
      })
      templateNames))
    // (lib.listToAttrs (map (name: {
        name = "noctalia/hooks/${name}";
        value.source = files + "/hooks/${name}";
      })
      hookNames));

  home.file =
    {
      ".local/bin/noctalia-theme" = {
        source = themeScript;
        executable = true;
      };
    }
    // lib.listToAttrs (map (file: {
        name = "Pictures/Wallpapers/${lib.removePrefix (wallpaperRoot + "/") (toString file)}";
        value.source = file;
      })
      wallpapers);

  # Files Noctalia writes at runtime (they must not be store symlinks).
  home.activation.noctaliaRuntime = lib.hm.dag.entryAfter ["linkGeneration"] ''
    set -eu
    export PATH=${lib.makeBinPath (with pkgs; [bash coreutils findutils gawk gnugrep gnused])}:$PATH

    mkdir -p \
      "$HOME/.config/kitty" \
      "$HOME/.config/bat/themes" \
      "$HOME/.config/lsd" \
      "$HOME/.config/fzf/themes" \
      "$HOME/.config/fish/conf.d" \
      "$HOME/.config/zellij/themes" \
      "$HOME/.config/yazi" \
      "$HOME/.config/lazygit/themes" \
      "$HOME/.config/opencode/themes" \
      "$HOME/.config/nvim/lua" \
      "$HOME/.pi/agent/themes" \
      "$HOME/.cache/dotfiles/noctalia" \
      "$HOME/.cache/noctalia/zen-browser"

    for f in \
      "$HOME/.config/kitty/kitty-colors.conf" \
      "$HOME/.config/bat/themes/noctalia.tmTheme" \
      "$HOME/.config/fzf/themes/noctalia" \
      "$HOME/.config/zellij/themes/noctalia.kdl" \
      "$HOME/.config/yazi/theme.toml" \
      "$HOME/.config/lazygit/themes/noctalia.yml" \
      "$HOME/.config/opencode/themes/matugen.json" \
      "$HOME/.pi/agent/themes/noctalia.json"; do
      [ -e "$f" ] || : > "$f"
    done

    [ -e "$HOME/.config/lsd/colors.yaml" ] || printf '{}\n' > "$HOME/.config/lsd/colors.yaml"
    [ -e "$HOME/.config/nvim/lua/matugen.lua" ] || cp ${../../files/neovim/matugen.lua} "$HOME/.config/nvim/lua/matugen.lua"

    # Resolve palette / mode / wallpaper from the runtime cache (or defaults).
    export NOCTALIA_WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
    export NOCTALIA_DEFAULT_PALETTE="Gruvbox"
    export NOCTALIA_DEFAULT_MODE="dark"

    resolved=""
    if [ -x ${themeScript} ]; then
      resolved="$(${themeScript} resolve 2>/dev/null || true)"
    fi

    palette="Gruvbox"
    mode="dark"
    wallpaper=""
    if [ -n "$resolved" ]; then
      IFS=$'\t' read -r palette mode wallpaper <<< "$resolved" || true
    fi

    wallpaper_dir="$HOME/Pictures/Wallpapers"
    if [ -n "$wallpaper" ]; then
      wallpaper_dir="$(dirname "$wallpaper")"
    fi

    cat > "$HOME/.config/noctalia/runtime.toml" <<EOF
    [wallpaper]
    directory = "$wallpaper_dir"

    [wallpaper.default]
    path = "$wallpaper"

    [theme]
    mode = "$mode"
    source = "custom"
    custom_palette = "$palette"

    [shell]
    font_family = "${config.my.fonts.ui}"

    [plugins]
    enabled = ${builtins.toJSON plugins}
    EOF
  '';
}
