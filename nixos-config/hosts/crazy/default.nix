# Host-specific settings AND the place where you choose what this host includes.
#
#   core modules (always)  : modules/nixos/core  + modules/home/core
#   system features (pick) : modules/nixos/features/*  → `features.<dir>.<file>`
#   users (pick)           : users/<name>.nix → `my.users = [ "<name>" ]`
#                            (each user brings their own Home-Manager features)
#
# The directory name of this host = its hostname.
{features, ...}: {
  imports =
    [
      ./hardware.nix # CPU/kernel modules (from nixos-generate-config)
      ./disko.nix # disk layout (partitioning + filesystems)
    ]
    # System features for this host
    ++ (with features; [
      desktop.niri
      desktop.noctalia
      desktop.greeter
      desktop.audio
      desktop.fonts
      desktop.apps
      hardware.nouveau
      ai.omniroute
    ]);

  # Users that exist on this host
  # Remember: each needs a "<name>-password" entry in secrets/secrets.yaml.
  # Users whose homeFeatures include desktop.* expect the matching system
  # features above.
  my.users = ["mohamed"];

  # Host platform
  nixpkgs.hostPlatform = "x86_64-linux";

  # Overriding the defaults
  time.timeZone = "Africa/Algiers";
  console.keyMap = "fr";

  # Do NOT change after install – it records the release you first installed with.
  system.stateVersion = "26.05";

  # Keep the modesetting driver enabled for this GPU.
  my.hardware.nouveau.forceNomodeset = false;
}
