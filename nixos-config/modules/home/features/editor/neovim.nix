# Neovim, built with nixCats.
#
# Plugins and runtime tools are installed by Nix. The Lua tree is linked
# file-by-file (not as a directory) so Noctalia can keep writing
# lua/matugen.lua at runtime without touching the Nix store.
{
  lib,
  pkgs,
  inputs,
  ...
}: let
  nvimDir = ../../files/neovim;
  luaFiles = lib.filesystem.listFilesRecursive (nvimDir + "/lua");

  codelldb = pkgs.runCommandLocal "codelldb" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb $out/bin/codelldb
  '';
in {
  imports = [inputs.nixCats.homeModule];

  home.packages = with pkgs; [
    gcc
    gnumake
    go
    just
    kdlfmt
    nodejs_22
    pipx
    python3
    terraform
    tree-sitter
    unzip
  ];

  nixCats = {
    enable = true;
    packageNames = ["nvim"];
    luaPath = nvimDir;

    categoryDefinitions.replace = {pkgs, ...}: {
      startupPlugins.general = with pkgs.vimPlugins; [
        alpha-nvim
        base16-nvim
        blink-cmp
        blink-cmp-conventional-commits
        blink-emoji-nvim
        blink-nerdfont-nvim
        codecompanion-nvim
        conform-nvim
        friendly-snippets
        gitsigns-nvim
        img-clip-nvim
        indent-blankline-nvim
        lazy-nvim
        lazydev-nvim
        lualine-nvim
        markview-nvim
        minuet-ai-nvim
        neo-tree-nvim
        noice-nvim
        nui-nvim
        nvim-dap
        nvim-dap-ui
        nvim-lint
        nvim-lspconfig
        nvim-nio
        nvim-notify
        nvim-treesitter.withAllGrammars
        nvim-web-devicons
        plenary-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        toggleterm-nvim
        which-key-nvim
      ];

      lspsAndRuntimeDeps.general = with pkgs; [
        # Language servers
        bash-language-server
        codebook
        css-variables-language-server
        docker-language-server
        emmet-language-server
        fish-lsp
        gopls
        graphql-language-service-cli
        harper
        helm-ls
        htmx-lsp
        intelephense
        jq-lsp
        just-lsp
        lua-language-server
        luau-lsp
        marksman
        nginx-language-server
        postgres-language-server
        pyright
        rust-analyzer
        sqls
        tailwindcss-language-server
        taplo
        terraform-ls
        vscode-langservers-extracted
        vtsls
        yaml-language-server

        # Formatters and linters
        eslint
        go
        gotools
        golangci-lint
        jq
        just
        luaPackages.luacheck
        markdownlint-cli
        nodejs_22
        phpPackages.php-cs-fixer
        prettier
        python3Packages.sqlfmt
        ruff
        rustfmt
        shellcheck
        shfmt
        stylua
        terraform
        yamllint
        fish

        # Debug adapters and editor helpers
        (python3.withPackages (ps: [ps.debugpy]))
        codelldb
        delve
        fd
        gcc
        gnumake
        kdlfmt
        lazygit
        ripgrep
        tree-sitter
        unzip
        wl-clipboard
      ];
    };

    packageDefinitions.replace.nvim = _: {
      settings = {
        suffix-path = true;
        suffix-LD = true;
        wrapRc = false;
        aliases = ["vim"];
        hosts.python3.enable = true;
        hosts.node.enable = true;
      };
      categories.general = true;
    };
  };

  xdg.configFile =
    {
      "nvim/init.lua".source = nvimDir + "/init.lua";
    }
    // lib.listToAttrs (map (file: {
        name = "nvim/lua/${lib.removePrefix (toString (nvimDir + "/lua") + "/") (toString file)}";
        value.source = file;
      })
      luaFiles);
}
