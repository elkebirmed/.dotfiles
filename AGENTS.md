# Rules

- Link static configs from role files instead of copying them to their destinations.
- Use templates only for values that need runtime or host-specific rendering. When the config format supports includes, keep the main config linked and render only the dynamic fragment. Use a full template only when the format requires a standalone generated file.
- The system role enables Chaotic-AUR as a free binary cache for AUR packages; AUR helpers can use cached packages when available and build from source when they are not.
- Don't create tasks that ensure the absent of things (if not needed), Just tell the user how to remove those things using CMDs.
- Make sure all packages has Bash/Fish compability (if existed), like completions, ...