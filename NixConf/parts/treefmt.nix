# treefmt-nix integration
#   nix fmt          → formats the whole repo
#   nix flake check  → fails if something is unformatted
{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = {
    treefmt = {
      # treefmt finds the repo root by looking for this file
      projectRootFile = "flake.nix";

      programs = {
        alejandra.enable = true; # the Nix formatter
        deadnix.enable = true; # find unused bindings
        statix.enable = true; # lint anti-patterns
      };

      settings.global.excludes = [
        "secrets/*" # never touch encrypted files
        "flake.lock"
        "*.md"
      ];
    };
  };
}
