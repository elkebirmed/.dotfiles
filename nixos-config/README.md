# NixOS configuration

The configuration is split into NixOS modules (system side) and Home-Manager
modules (user side), with a small flake-parts layer around them:

- `parts/` — flake-parts wiring (hosts, deploy, devshell, formatting)
- `hosts/<name>/` — hardware, disk layout and the feature/user selection
- `users/<name>.nix` — plain user data plus the Home-Manager features it gets
- `modules/nixos/core` — always loaded on every host
- `modules/nixos/features` — opt-in system features
- `modules/home/core` — always loaded for every user
- `modules/home/features` — opt-in user features
- `modules/home/files` — static configuration used by the Home-Manager modules

Everything the system needs at build time is inside this directory, so the
flake is self-contained and can be deployed on its own.

## Daily use

```sh
# from the root of this configuration

nix develop            # tools: deploy-rs, disko, sops, nixos-anywhere, nixd…
nix fmt                # alejandra + deadnix + statix
nix flake check        # formatting + deploy-rs sanity checks

sudo nixos-rebuild switch --flake .#crazy
deploy .#crazy         # remote deploy with automatic rollback
```

The host name (`crazy`) is the directory name in `hosts/`.

## What maps to what

| Tool / area | NixOS / Home-Manager module |
| --- | --- |
| base system | `nixos/core/base.nix`, `nixos/features/desktop/fonts.nix` |
| bash, fish, starship, fzf, bat, lsd, zoxide, fd, ripgrep, gh, lazygit | `home/core/shell.nix` |
| git, ssh | `home/core/git.nix`, `home/core/ssh.nix` |
| nodejs, python, go, rust | `home/features/dev/*` |
| neovim | `home/features/editor/neovim.nix` |
| kitty, zellij, yazi, zen browser | `home/features/desktop/{apps,yazi}.nix` |
| niri | `nixos/features/desktop/niri.nix` + `home/features/desktop/niri.nix` |
| noctalia | `nixos/features/desktop/noctalia.nix` + `home/features/desktop/noctalia.nix` |
| noctalia greeter | `nixos/features/desktop/greeter.nix` |
| wallpapers | `home/features/desktop/noctalia.nix` (`~/Pictures/Wallpapers`) |
| omniroute, opencode, pi | `home/features/ai/*` + `nixos/features/ai/omniroute.nix` |
| nouveau | `nixos/features/hardware/nouveau.nix` |

Notes:

- `niri` uses the **niri-unstable** package through `niri-flake`'s overlay.
- Noctalia and Noctalia Greeter come from their flakes.
- Noctalia keeps writing its theme files at runtime. Those targets are created
  by Home-Manager activation as writable files, not as read-only store links.
- The runtime palette/mode/wallpaper choice in
  `~/.cache/dotfiles/noctalia/theme` is re-applied on every switch.
- `uv` replaces `pyenv`; `sqlfmt` comes from `python3Packages.sqlfmt`.
  `kdl-lsp` is not packaged in nixpkgs; KDL files are formatted with
  `kdlfmt`.
- `omniroute` and `pi` come from their flakes (`omniroute-nix` and the official
  Pi flake), so no npm install is needed. OmniRoute reads its initial password,
  API key and provider keys from the sops-rendered
  `/run/secrets/rendered/omniroute.env`; the system user service lives in
  `nixos/features/ai/omniroute.nix`.
- Neovim is built with nixCats: plugins, LSP servers, formatters and DAP
  adapters are installed by Nix, while lazy.nvim only loads them.

## Secrets

See [`secrets/README.md`](secrets/README.md). In short:

- the age identity is the target's `/etc/ssh/ssh_host_ed25519_key`;
- `secrets/secrets.yaml` is encrypted with sops and contains the secrets used by
  this configuration (`GH_TOKEN`, the OmniRoute/provider keys and the user
  password hash);
- `<user>-password` is a `mkpasswd -m sha-512`/`openssl passwd -6` hash; change
  the generated initial password after the first login;
- add the target host key as an extra recipient before deploying (see
  [`secrets/README.md`](secrets/README.md)).

---

## Install on a fresh machine (disko)

Run these commands from the root of this configuration.

Two ways to do it. Both wipe the target disk, so check the device names in
the disko config first (`lsblk`).

- **A. Remote**: run from your current machine, install over SSH with nixos-anywhere.
- **B. Local**: run on the target itself, booted from the NixOS installer ISO.

Either way, first prepare the host key so sops can decrypt on first boot.

### 0. Prepare the host key (both methods)

Do this on your current machine:

```sh
tmp=$(mktemp -d)
install -d -m 755 "$tmp/etc/ssh"
ssh-keygen -t ed25519 -N "" -f "$tmp/etc/ssh/ssh_host_ed25519_key"
chmod 600 "$tmp/etc/ssh/ssh_host_ed25519_key"

nix run nixpkgs#ssh-to-age -- < "$tmp/etc/ssh/ssh_host_ed25519_key.pub"
# add the age1... key to the `&crazy` entry in .sops.yaml and uncomment `*crazy`
# in the secrets/secrets.yaml creation rule
sops updatekeys secrets/secrets.yaml
```

`secrets/secrets.yaml` is already encrypted with the personal key; adding the
target host key to `.sops.yaml` and running `sops updatekeys` makes the file
decryptable on first boot. See [`secrets/README.md`](secrets/README.md) for the
key list and password details.

If the host already exists, copy its existing key into `$tmp/etc/ssh/` instead.

---

### A. Install over SSH (from your current machine)

The target needs to be booted into the NixOS installer (or any Linux with
kexec) with root SSH access and at least ~1.5 GB RAM.

**1. Get SSH access to the target.** On the target:

```sh
sudo passwd root          # temporary, only for the first connection
ip -4 addr                # note the IP
```

From your current machine:

```sh
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<ip>
ssh root@<ip> lsblk       # confirm disk matches the disko config
```

**2. Install:**

```sh
nix run github:nix-community/nixos-anywhere -- \
  --flake .#crazy \
  --extra-files "$tmp" \
  root@<ip>
```

`--extra-files` takes the directory that *contains* `etc/`, hence `$tmp`.
This partitions, installs, copies the host key and reboots.

**3. After the reboot:**

```sh
ssh-keygen -R <ip>        # clear the old installer host key
ssh <user>@<ip>
```

---

### B. Install locally (on the target machine itself)

**1. Boot the NixOS installer ISO**, get network access, then:

```sh
git clone <repo-url> nixos-config && cd nixos-config
```

**2. Partition and mount with disko:**

```sh
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake .#crazy
```

This mounts the new system under `/mnt`.

**3. Place the host key** (copy `$tmp/etc/ssh/*` from your other machine,
e.g. with `scp` or a USB stick):

```sh
sudo install -d -m 755 /mnt/etc/ssh
sudo install -m 600 ssh_host_ed25519_key     /mnt/etc/ssh/
sudo install -m 644 ssh_host_ed25519_key.pub /mnt/etc/ssh/
```

**4. Install and reboot:**

```sh
sudo nixos-install --flake .#crazy --no-root-passwd
sudo reboot
```

---

### Cleanup

```sh
rm -rf "$tmp"             # remove the local copy of the private host key
```
