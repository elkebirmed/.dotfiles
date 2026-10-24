# Base system configuration shared by every host.
{
  pkgs,
  hostName,
  ...
}: let
  caches = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://noctalia.cachix.org"
      "https://yazi.cachix.org"
      "https://niri-epireyn.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
    ];
  };
in {
  # ---------------------------------------------------------------------------
  # Nix
  # ---------------------------------------------------------------------------
  nix = {
    settings =
      caches
      // {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = ["root" "@wheel"];
        auto-optimise-store = true;
      };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;

  # ---------------------------------------------------------------------------
  # Boot
  # ---------------------------------------------------------------------------
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------
  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  programs.fish.enable = true;

  # ---------------------------------------------------------------------------
  # Locale, time, keyboard
  # ---------------------------------------------------------------------------
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "fr,ara";
    model = "pc105";
    options = "caps:none,grp:alt_shift_toggle";
  };

  # Qt applications use the GTK platform theme so they pick up GTK fonts.
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "gtk2";

  # ---------------------------------------------------------------------------
  # Services
  # ---------------------------------------------------------------------------
  services.fstrim.enable = true;
  services.timesyncd.enable = true;

  # Ignore the power button (a long press still performs an emergency shutdown).
  services.logind.settings.Login.HandlePowerKey = "ignore";

  # Allow members of the wheel group to use sudo without a password prompt.
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;

  # ---------------------------------------------------------------------------
  # Packages
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    age
    bzip2
    curl
    diffutils
    file
    gcc
    git
    gnumake
    gnutar
    gzip
    htop
    jq
    man-db
    man-pages
    openiscsi
    openssh
    patch
    pkg-config
    rsync
    sops
    tree
    unzip
    wget
    xz
    zip
    zstd
  ];
}
