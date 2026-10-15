# Mohamed dotfiles

## Development

- Link static configs from role files instead of copying them to their destinations.
- Use templates only for values that need runtime or host-specific rendering. When the config format supports includes, keep the main config linked and render only the dynamic fragment. Use a full template only when the format requires a standalone generated file.
- Keep application configuration in its owning role. For example, the `noctalia` role installs the Noctalia Base16 palette; shared color values live in `group_vars/all/base16.yml`.
- The system role enables Chaotic-AUR as a free binary cache for AUR packages; AUR helpers can use cached packages when available and build from source when they are not.