# Secrets

`secrets/secrets.yaml` is managed by [sops](https://github.com/getsops/sops) and
consumed by [sops-nix](https://github.com/Mic92/sops-nix). It contains the
values used by this configuration.

## Keys

| Key | Used by |
| --- | --- |
| `mohamed-password` | NixOS user password (`/run/secrets-for-users/mohamed-password`) |
| `GH_TOKEN` | fish `gh` wrapper (`/run/secrets/GH_TOKEN`) |
| `OMNIROUTE_PASSWORD` | OmniRoute `INITIAL_PASSWORD` |
| `OMNIROUTE_SECRET_KEY` | OmniRoute `API_KEY_SECRET` |
| `OMNIROUTE_API_KEY` | OpenCode/Pi and `~/.omniroute/api-key` |
| `OPENROUTER_API_KEY` | OmniRoute environment |
| `KIMI_API_KEY` | OmniRoute environment |
| `git_user_email` | Git identity email (also declared in `users/mohamed.nix`) |

`sops-nix` renders the OmniRoute environment to
`/run/secrets/rendered/omniroute.env` (mode `0400`, owned by the desktop user).
The user service in `modules/nixos/features/ai/omniroute.nix` reads that file
directly, so the secrets never enter the Nix store.

## Initial password

`mohamed-password` is a SHA-512 crypt hash (`$6$...`) of a generated initial
password. Change it after the first login:

```sh
passwd
```

To set your own password hash instead, edit the sops file and replace the value:

```sh
sops secrets/secrets.yaml
# mohamed-password: <output of: mkpasswd -m sha-512>
# or:              <output of: openssl passwd -6>
```

## Add the target host key

The age identity is the target machine's SSH host key
(`/etc/ssh/ssh_host_ed25519_key`), so no extra key has to be copied to the host.
The file is currently encrypted with the personal key in `.sops.yaml`; add the
target key as a second recipient before deploying.

1. Get the machine's age public key:

   ```sh
   nix shell nixpkgs#ssh-to-age -c \
     sh -c 'ssh-keyscan -t ed25519 localhost 2>/dev/null | ssh-to-age'
   ```

   Or, on the target itself:

   ```sh
   ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
   ```

2. Add the key to `.sops.yaml`:

   - uncomment (or add) the `&crazy` entry under `keys`;
   - uncomment `*crazy` in the `secrets/secrets.yaml` creation rule;
   - refresh the recipients:

   ```sh
   sops updatekeys secrets/secrets.yaml
   ```

   The personal key stays in the rule so the file can still be edited on the
   workstation. See the "Install on a fresh machine" section of
   [`../README.md`](../README.md) for generating the host key before install.

3. Deploy/switch. `nixos-rebuild` writes the decrypted password hash to
   `/run/secrets-for-users/mohamed-password` before creating users.

## Notes

- Do not commit a plaintext copy of this file.
- The generated initial password was provided separately (not committed here);
  change it after the first login.
