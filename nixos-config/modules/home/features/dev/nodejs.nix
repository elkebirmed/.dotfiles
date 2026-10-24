# Node.js with fnm + pnpm.
{pkgs, ...}: let
  completions =
    pkgs.runCommandLocal "node-fish-completions" {
      nativeBuildInputs = with pkgs; [fnm pnpm];
    } ''
      mkdir -p $out
      fnm completions --shell fish > $out/fnm.fish || true
      pnpm completion fish > $out/pnpm.fish || true
    '';
in {
  home.packages = with pkgs; [
    fnm
    nodejs_22
    pnpm
  ];

  xdg.configFile = {
    "fish/completions/fnm.fish".source = "${completions}/fnm.fish";
    "fish/completions/pnpm.fish".source = "${completions}/pnpm.fish";
  };
}
