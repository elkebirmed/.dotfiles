# Mohamed dotfiles

## Theming (Noctalia)

Theming is driven by [Noctalia](https://github.com/noctalia-dev/noctalia) custom palettes instead of wallpaper
generation:

- `roles/noctalia/files/palettes/` holds the Noctalia core palette JSON files (Ayu, Catppuccin, Dracula,
  Eldritch, Gruvbox, Kanagawa, Monochrome, Nord, One-Dark, Rosepine, Tokyo-Night), downloaded from the
  Noctalia repository and linked into `~/.config/noctalia/palettes/`. Each palette ships both a `dark` and a
  `light` variant.
- `Gruvbox` (dark) is the default palette unless `~/.cache/dotfiles/noctalia/theme` records a runtime choice.

### Wallpapers

Wallpapers are organised per palette under `roles/wallpapers/files/Wallpapers/` (linked into
`~/Pictures/Wallpapers/`):

```
Wallpapers/<Palette>/Dark/*.jpg    # palette is used in dark mode
Wallpapers/<Palette>/Light/*.jpg   # palette is used in light mode
Wallpapers/<Palette>/*.jpg         # no Dark/Light sub-folders: used for both modes
```

- A palette with only a `Dark` (or only a `Light`) sub-folder is used in that mode alone.
- A palette with no wallpaper folder at all gets a random wallpaper from the whole tree.

The palette name is matched to its folder by lower-casing it and dropping every non-alphanumeric character, so
`Tokyo-Night` matches `Tokyo Night` and `One-Dark` matches `One Dark`. Drop new wallpapers into the matching
folder and they become available immediately — no Ansible change needed.

### Palette and wallpaper switching (runtime)

`~/.local/bin/noctalia-theme` applies a palette, its mode and its wallpaper as one unit:

| Command | Action |
|---------|--------|
| `next` / `prev` / `random` | Cycle palettes available in the current mode |
| `dark` / `light` / `mode` | Set or toggle dark/light mode |
| `wallpaper-next` / `wallpaper-prev` / `wallpaper-random` | Cycle wallpapers of the active palette |
| `set <palette>` | Activate a palette (switches mode if needed) |
| `current` / `list` / `resolve` | Inspect the active theme / available palettes |

The script applies the change live through `noctalia msg` and records palette, mode and wallpaper in
`~/.cache/dotfiles/noctalia/theme`. On the next Ansible run the noctalia role re-applies that exact choice.

Bindings in niri (`roles/niri/files/binds.kdl`):

| Binding | Action |
|---------|--------|
| `Mod+Shift+T` | Next palette |
| `Mod+Ctrl+Shift+T` | Previous palette |
| `Mod+Alt+T` | Random palette |
| `Mod+Shift+Y` | Toggle dark/light mode |
| `Mod+Shift+W` | Next wallpaper |
| `Mod+Ctrl+Shift+W` | Previous wallpaper |
| `Mod+Alt+W` | Random wallpaper |

### Fish shell

Fish gets its theme from the active palette via the `fish-colors.fish` Noctalia template, rendered into
`~/.config/fish/conf.d/noctalia-colors.fish` on every theme change.
