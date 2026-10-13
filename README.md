# Mohamed dotfiles

Ansible playbook that configures an Arch Linux machine — packages, locale, mirrors,
services, shell, git and omp — from a single repository. It runs on the local machine
as a normal user and obtains root privileges through sudo, per role.

## Requirements

- Arch Linux and a normal (non-root) user with sudo
- `ansible` (installed by `install` when missing)

## Usage

```sh
./install              # pull, install Galaxy requirements, run the playbook
./install -n           # skip git pull
./install -c           # dry run (--check --diff)
./install --tags git   # anything else is passed to ansible-playbook
```

On a fresh machine:

```sh
curl -fsSL https://raw.githubusercontent.com/elkebirmed/dotfiles/main/install | bash
```

## Layout

| Path | Purpose |
| --- | --- |
| `playbook.yml` | The single play: runs the configured roles against `localhost` |
| `inventory/hosts` | Local-only inventory (`localhost`, `connection=local`) |
| `roles/` | One role per concern: `system`, `git`, `bash`, `ai` |
| `group_vars/all/` | Variables for every machine; `*.sops.yaml` holds secrets |
| `host_vars/localhost/` | Variables for this machine |
| `docs/SECRETS.md` | How SOPS/age encryption works here |
| `scripts/setup-sops-age` | Generates the age identity and `.sops.yaml` |

The inventory host is always `localhost` because the playbook configures the machine
it runs on; per-machine values therefore live in `host_vars/localhost/`.

## Roles and tags

`group_vars/all/roles.yml` decides which roles run and in which order. Every role is
also selectable by tag:

| Tag | Role | What it does |
| --- | --- | --- |
| `system` | `system` | pacman config, upgrade, packages, sudoers, reflector, hostname/timezone/locale/keymap, services, logind, sysctl |
| `git` | `git` | global `init.defaultBranch`, `user.name`, `user.email` |
| `bash` | `bash` | `~/.bashrc` bootstrap and the `~/.config/bash/` drop-in directory |
| `ai` | `ai` | installs `omp`, writes its OpenRouter provider config and the `omp()` wrapper |

The system role has sub-tags: `pacman`, `sudoers`, `packages`, `reflector`, `locale`,
`services`, `logind`, `sysctl`, plus `upgrade` for the full system upgrade.

```sh
ansible-playbook playbook.yml --tags git        # only the git role
ansible-playbook playbook.yml --skip-tags upgrade
```

## Secrets

Secrets (`group_vars/all/*.sops.yaml`: the OpenRouter key, the git email) are decrypted
at run time by the `community.sops.sops` vars plugin, which needs the age identity on
the controller. See `docs/SECRETS.md`.

`omp` does not read secrets from the environment: `~/.config/bash/omp.sh` wraps it in
`sops exec-env`, so the key is injected for that command only and never written to
disk in plaintext:

```sh
omp() {
  sops exec-env "$HOME/.dotfiles/group_vars/all/ai.sops.yaml" -- "$HOME/.local/bin/omp" "$@"
}
```

`ai_version` pins the omp release that gets installed; the binary is only fetched when
`~/.local/bin/omp` is missing, so bump the pin and remove the binary to upgrade.

## Tooling

```sh
ansible-lint                                    # configuration in .ansible-lint
ansible-playbook --syntax-check playbook.yml
```

CI runs both on every push and pull request (`.github/workflows/lint.yml`).
