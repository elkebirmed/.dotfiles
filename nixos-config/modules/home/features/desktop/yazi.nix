# Yazi file manager and its preview helpers.
{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages = with pkgs; [
    chafa
    exiftool
    ffmpegthumbnailer
    mediainfo
    ueberzugpp
    _7zz
  ];

  programs.yazi = {
    enable = true;
    package = inputs.yazi.packages.${system}.yazi;
    shellWrapperName = "y";
    enableFishIntegration = true;

    settings = {
      mgr = {
        ratio = [1 4 3];
        sort_by = "natural";
        sort_sensitive = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = false;
        show_symlink = true;
        scrolloff = 5;
      };
      preview = {
        wrap = "no";
        tab_size = 2;
        max_width = 600;
      };
    };

    keymap.mgr.prepend_keymap = [
      {
        on = "T";
        run = "shell 'lazygit' --block";
        desc = "Open Lazygit";
      }
    ];
  };
}
