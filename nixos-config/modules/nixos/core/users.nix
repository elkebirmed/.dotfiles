# Declarative users + their Home-Manager environments.
#
# A user is plain data in users/<name>.nix. The same file picks the Home-Manager
# features that user gets, so `users/mohamed.nix` is the only place to look.
{
  config,
  lib,
  pkgs,
  inputs,
  userDefs,
  homeCore,
  homeFeatures,
  ...
}: let
  cfg = config.my;
  inherit (cfg) users;

  defaultGroups = [
    "networkmanager"
    "video"
    "audio"
    "input"
  ];

  adminUsers = lib.filter (name: userDefs.${name}.admin or false) users;
in {
  options.my.users = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Users (files in users/) that exist on this host.";
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = lib.all (name: builtins.hasAttr name userDefs) users;
          message = "my.users contains a name without a matching users/<name>.nix file.";
        }
      ];

      users.users =
        lib.genAttrs users (name: let
          def = userDefs.${name};
        in {
          isNormalUser = true;
          description = def.fullName or name;
          shell = pkgs.fish;
          extraGroups =
            defaultGroups
            ++ lib.optional (def.admin or false) "wheel"
            ++ (def.extraGroups or []);
          openssh.authorizedKeys.keys = def.sshKeys or [];
          hashedPasswordFile = config.sops.secrets."${name}-password".path;
        })
        // {
          # deploy-rs logs in as root with the admin users' SSH keys.
          root.openssh.authorizedKeys.keys =
            lib.concatMap (name: userDefs.${name}.sshKeys or []) adminUsers;
        };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";

        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.noctalia.homeModules.default
          inputs.zen-browser.homeModules.beta
        ];

        extraSpecialArgs = {
          inherit inputs userDefs;
          features = homeFeatures;
        };

        users = lib.genAttrs users (name: {...}: {
          imports = homeCore ++ ((userDefs.${name}.homeFeatures or (_: [])) homeFeatures);

          home.username = name;
          home.homeDirectory = "/home/${name}";

          _module.args.user = userDefs.${name};
          _module.args.username = name;
        });
      };
    }
  ];
}
