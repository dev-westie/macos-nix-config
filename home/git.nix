{ primaryUser, ... }:
{
  programs.git = {
    enable = true;

    ignores = [ "**/.DS_STORE" ];

    settings = {
      user.name = "westie";
      user.email = "westie.dev@proton.me"; # TODO: confirm this is the email on your GitHub account

      github.user = primaryUser;

      init.defaultBranch = "main";
      pull.rebase = true; # `git pull` replays local commits instead of merge-committing
      push.autoSetupRemote = true; # `git push` on a new branch works without --set-upstream
      core.editor = "nvim";
    };
  };
}
