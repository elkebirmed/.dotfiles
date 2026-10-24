# One file per person. File name = login name. Plain data (not a module).
# To create a user: copy this file, then add `<name>-password` to secrets/secrets.yaml
# and select the user in a host with `my.users = [ "<name>" ];`.
{
  fullName = "mohamed";
  email = "mohamedelkebirme@gmail.com";

  # admin = true → member of `wheel` (sudo) AND her SSH keys may log in as root,
  # which is what deploy-rs uses.
  admin = true;

  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN8+qPHnSDa2UnRFj5xrN4NQvRer5a+Nnn/Q3fz4dHjN bureau-pc@DESKTOP-932LUCP"
  ];

  # Optional (default: networkmanager, video, audio)
  # extraGroups = ["networkmanager" "video" "audio" "docker"];

  # This user's Home-Manager features, picked from modules/home/features.
  # (`f` is the haumea tree: f.editor.nixcats, f.dev.rust, ...)
  homeFeatures = f:
    with f; [
      editor.nixcats
      dev.rust
      desktop.niri
      desktop.yazi
      desktop.noctalia
      desktop.apps
    ];
}