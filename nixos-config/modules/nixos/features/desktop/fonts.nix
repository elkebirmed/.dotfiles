# Fonts used by the shell, terminal, editor and greeter.
{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      maple-mono.NF
      maple-mono.NF-CN
      noto-fonts
      noto-fonts-color-emoji
      rubik
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = ["Noto Sans Arabic"];
        serif = ["Noto Serif Arabic"];
        monospace = ["Maple Mono NF"];
      };
    };
  };
}
