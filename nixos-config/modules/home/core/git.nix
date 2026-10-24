# Git identity and repository defaults.
{user, ...}: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = user.fullName;
        inherit (user) email;
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  home.file.".gitattributes".source = ../files/git/gitattributes;
}
