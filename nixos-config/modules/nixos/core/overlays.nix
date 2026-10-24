# Adds the rust-overlay so `pkgs.rust-bin` is available to Home-Manager.
{inputs, ...}: {
  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
}
