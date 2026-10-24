# OpenSSH client defaults.
_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;
    };
  };
}
