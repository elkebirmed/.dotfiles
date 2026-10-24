# Secrets are managed by sops-nix.
#
# The age identity is the machine's SSH host key, so nothing extra has to be
# copied to the host. The encrypted file is secrets/secrets.yaml.
#
# The keys in this file are:
#   <name>-password      hashed login password (mkpasswd / openssl passwd -6)
#   GH_TOKEN             GitHub CLI token
#   OMNIROUTE_PASSWORD   OmniRoute initial password
#   OMNIROUTE_SECRET_KEY OmniRoute API key secret
#   OMNIROUTE_API_KEY    OmniRoute client API key
#   OPENROUTER_API_KEY   provider key
#   KIMI_API_KEY         provider key
{
  config,
  lib,
  ...
}: let
  owner = lib.head config.my.users;
in {
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    validateSopsFiles = true;

    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    gnupg.sshKeyPaths = [];

    secrets =
      {
        "${owner}-password".neededForUsers = true;
      }
      // lib.genAttrs [
        "GH_TOKEN"
        "OMNIROUTE_PASSWORD"
        "OMNIROUTE_SECRET_KEY"
        "OMNIROUTE_API_KEY"
        "OPENROUTER_API_KEY"
        "KIMI_API_KEY"
      ] (_: {
        inherit owner;
        mode = "0400";
      });

    # The OmniRoute service reads this file directly; it is rendered from the
    # same secrets and kept out of the Nix store.
    templates."omniroute.env" = {
      inherit owner;
      mode = "0400";
      content = ''
        PORT=20128
        OMNIROUTE_SERVER_HOST=127.0.0.1
        REQUIRE_API_KEY=true
        OMNIROUTE_API_KEY=${builtins.toJSON config.sops.placeholder."OMNIROUTE_API_KEY"}
        API_KEY_SECRET=${builtins.toJSON config.sops.placeholder."OMNIROUTE_SECRET_KEY"}
        INITIAL_PASSWORD=${builtins.toJSON config.sops.placeholder."OMNIROUTE_PASSWORD"}
        OPENROUTER_API_KEY=${builtins.toJSON config.sops.placeholder."OPENROUTER_API_KEY"}
        KIMI_API_KEY=${builtins.toJSON config.sops.placeholder."KIMI_API_KEY"}
      '';
    };
  };
}
