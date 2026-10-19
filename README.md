# Mohamed dotfiles

## Theming (Noctalia)

Theming is driven by [Noctalia](https://github.com/noctalia-dev/noctalia) custom palettes instead of wallpaper
generation:

- `group_vars/all/noctalia.yml` lists the bundled Noctalia core palettes and the wallpaper paired with each
  palette (`noctalia_palette_wallpapers`). Replace the wallpaper file names with your own picks anytime.
- `roles/noctalia/files/palettes/` holds the core palette JSON files (Ayu, Catppuccin, Dracula, Eldritch,
  Gruvbox, Kanagawa, Noctalia, Nord, Rosepine, Tokyo-Night), downloaded from the Noctalia repository and linked
  into `~/.config/noctalia/palettes/`.
- `Gruvbox` is the default palette unless `~/.cache/dotfiles/noctalia/palette` holds a runtime choice.
- `~/.config/noctalia/palette-wallpapers.tsv` maps every palette to its wallpaper and is consumed by
  `~/.local/bin/noctalia-theme`.

### Palette switching (runtime)

Bindings in niri (`roles/niri/files/binds.kdl`):

| Binding | Action |
|---------|--------|
| `Mod+Shift+T` | Next palette + paired wallpaper |
| `Mod+Ctrl+Shift+T` | Previous palette + paired wallpaper |
| `Mod+Alt+T` | Random palette + paired wallpaper |

They run `~/.local/bin/noctalia-theme {next,prev,random,set <palette>}`. The script applies the palette and
wallpaper live through `noctalia msg` and remembers the choice in
`~/.cache/dotfiles/noctalia/palette`. On the next Ansible run, the noctalia role re-applies that palette and
wallpaper from the cache.

### Fish shell

Fish gets its theme from the active palette via the `fish-colors.fish` Noctalia template, rendered into
`~/.config/fish/conf.d/noctalia-colors.fish` on every theme change.
