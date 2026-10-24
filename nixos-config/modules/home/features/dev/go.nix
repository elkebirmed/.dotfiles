# Go toolchain, language server, and debugger.
{pkgs, ...}: {
  home.packages = with pkgs; [
    delve
    go
    gopls
    gotools
  ];

  xdg.configFile."fish/conf.d/go.fish".text = ''
    # Go
    set -gx GOPATH "$HOME/go"
    fish_add_path "$GOPATH/bin"
  '';
}
