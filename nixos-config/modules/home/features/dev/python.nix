# Python development environment.
#
# pyenv is replaced by uv, which fills the same role on NixOS without having to
# build Python interpreters outside the store.
{pkgs, ...}: {
  home.packages = with pkgs; [
    pipx
    python3
    python3Packages.pynvim
    uv
  ];
}
