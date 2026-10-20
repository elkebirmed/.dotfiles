# AGENTS.md

This repository is a dotfiles/Ansible configuration for a Linux workstation. The goal is to keep the setup reproducible, declarative, and easy to maintain.

## Core principles

- Prefer role-owned config files over copied files.
  - Keep static configuration in the relevant role under `roles/<role>/files/` or `roles/<role>/templates/`.
  - Link or install those files into the target paths instead of duplicating them in-place.
  - If the target format supports includes or fragments, keep the base config in the repo and render only the dynamic part.
  - Only use a full template when the destination file must be generated as a single unit.

- Use templates only for values that must be runtime- or host-specific.
  - Values like paths, package names, hostnames, user-specific settings, or machine-specific state belong in Jinja templates or `group_vars` / `host_vars`.
  - Static defaults should stay as plain files and be reused without templating.

- Keep shell and package integration complete.
  - If a package or tool exposes Bash or Fish completion, ensure the repo includes/installs the appropriate completion files.
  - Prefer package-provided completion files when available; if custom wrappers are required, keep them in the matching role.
  - Shell config should be composable and idempotent.

- Use the system role's AUR setup correctly.
  - The system role enables Chaotic-AUR as a free binary cache for AUR packages.
  - AUR helpers may use cached packages when available and fall back to building from source when they are not.
  - Do not add unnecessary custom AUR workarounds when the package can be installed normally via the configured cache.

- Prefer removal guidance over "ensure absent" tasks.
  - When a change is optional or can be reversed, tell the user how to remove it with commands instead of creating extra tasks that merely assert nonexistence.
  - Avoid unnecessary cleanup jobs unless they are truly required for the setup.

- Do not commit or push changes.
  - Treat this repo as local configuration management, not a code review / release branch workflow.

## Repository conventions

- Keep role logic in `roles/` and shared variables in `group_vars/` and `host_vars/`.
- Prefer small, focused roles and idempotent Ansible tasks.
- Preserve host-specific differences via `inventory/hosts`, `group_vars`, and `host_vars` rather than hardcoding machine assumptions in role files.
- When editing config that affects a shell, desktop environment, or package manager, check the matching role and any related completions/templates instead of patching the installed config directly.

## Theming sync and cache

- The theming system is driven by Noctalia palettes and wallpapers, not by hardcoded wallpaper generation.
- Runtime theme state is cached in `~/.cache/dotfiles/noctalia/theme` and should be treated as the source of truth for the current live palette, dark/light mode, and selected wallpaper.
- The `~/.local/bin/noctalia-theme` script updates the live theme immediately and writes the state back to that cache file.
- On the next Ansible run, the `noctalia` role should re-apply the cached choice so the declarative config and the live runtime state stay aligned.
- Palette definitions live under `roles/noctalia/files/palettes/`; wallpapers live under `roles/wallpapers/files/Wallpapers/` and are discovered by palette name and mode.
- When adding or changing palettes or wallpaper folders, ensure the matching folder layout remains compatible with the runtime selector and that no manual theme changes are silently lost.
- If a theme change is intentional, keep the runtime cache and the repo-managed config in sync rather than editing only one side.

## Editing guidance for agents

- Audit the relevant role before changing files.
- Prefer changing the source-of-truth config in the role and reusing the generated output via links or templates.
- When adding new config, keep it static unless a value really depends on runtime or machine state.
- If a feature is environment-specific, render it through a template and keep the base logic in a repo file that remains readable and maintainable.
- When introducing packages or tools, also verify the corresponding Bash/Fish compatibility and completion path.

## Short checklist

Before finishing a change, verify:

- Static config is linked from the role rather than duplicated.
- Dynamic values are rendered via templates only where needed.
- Shell completions are present for relevant tools.
- Changes preserve idempotence and the repo's declarative pattern.
- No git commit or push was performed.

This file should be treated as the working policy for the repository and should guide future dotfiles changes.