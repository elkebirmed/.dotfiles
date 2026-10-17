# Secrets management

This repository uses SOPS with age to encrypt Ansible group and host variables.
Encrypted files ending in `.sops.yaml`, `.sops.yml`, or `.sops.json` in
`group_vars/` and `host_vars/` are loaded by the `community.sops.sops` vars
plugin during playbook runs.

The `omniroute` role renders OmniRoute runtime settings to
`~/.omniroute/.env` with user-only permissions. It generates a persistent
64-character API key at `~/.omniroute/api-key`, also with user-only
permissions, and requires that key for requests to the loopback service. Bash
and Fish no longer export it globally. Claude Code, OpenCode, and Pi receive
the key in their user-only configuration files.
Do not expose the service beyond loopback. Provider credentials
are managed by OmniRoute and are not written to this repository's generated
client configs.
The initial dashboard password is read from the encrypted `OMNIROUTE_PASSWORD`
variable and rendered as `INITIAL_PASSWORD` in the same `.env` file.
The `omniroute` role removes configured combos and obsolete shell launchers.
Claude Code, OpenCode, and Pi are configured to access OmniRoute without
selecting a default model; choose the model in the editor.

## First-time setup

The `age` and `sops` packages and the `community.sops` Ansible collection are
installed by the existing system package and Galaxy requirements configuration.
Generate a local age identity and the repository's `.sops.yaml` recipient
configuration with:

```sh
./scripts/setup-sops-age
```

The private identity is stored at
`$XDG_CONFIG_HOME/sops/age/keys.txt` (or `~/.config/sops/age/keys.txt` when
`XDG_CONFIG_HOME` is unset) with permissions restricted to the current user.
It is not stored in this repository. The generated
`.sops.yaml` contains only the public recipient and should be committed so the
repo can encrypt files consistently. Share only the public recipient when
adding another machine; never share or commit the private identity.
