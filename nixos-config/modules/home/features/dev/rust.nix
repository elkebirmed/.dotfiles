# Rust toolchain from rust-overlay.
{pkgs, ...}: {
  home.packages = [
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = [
        "rust-analyzer"
        "rust-src"
        "clippy"
        "rustfmt"
      ];
    })
  ];
}
