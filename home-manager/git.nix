let
  name = "Artem Sokolov";
  mail = "arsokolov@ptsecurity.com";
in
{
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = "Sombrer0Dev";
      push.autoSetupRemote = true;

      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      delta.features = "cyberdream";
      "delta \"decorations\"".syntax-theme = "cyberdream";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      alias = {
        recent = "!git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ | head -n 100";
        current = "rev-parse --abbrev-ref HEAD";

        # worktrees
        wa = "worktree add";
        wl = "worktree list";
        wr = "worktree remove";
        # Stolen))
        pam = "!BRANCH=`git recent | fzf` && git checkout \${BRANCH}";
        pamadd = "!FILES=`git status -s | awk '{ print $2 }' | fzf -x -m` && git add --all \${FILES}";
        pamfix = "!HASH=`git log --pretty=oneline | head -n 100 | fzf` && git fixit `echo \${HASH} | awk '{ print $1 }'`";
        pamshow = "!HASH=`git log --pretty=oneline | head -n 100 | fzf` && git show `echo \${HASH} | awk '{ print $1 }'`";
        pamrevert = "!HASH=`git log --pretty=oneline | head -n 100 | fzf` && git revert `echo \${HASH} | awk '{ print $1 }'`";
        pamlog = "!HASH=`git log --pretty=oneline | head -n 100 | fzf` && echo \${HASH} | awk '{ print $1 }' | xargs echo -n | pbcopy";
        pamrebase = "!HASH=`git log --pretty=oneline | head -n 100 | fzf` && git rebase -i `echo \${HASH} | awk '{ print $1 }'`^";
        pamvim = "!FILES=`git status -s | awk '{ print $2 }' | fzf -x -m` && nvim -O \${FILES}";
        pamvimconflicts = "!FILES=`git status -s | grep '^[UMDA]\\{2\\} ' | awk '{ print $2 }' | fzf -x -m` && nvim -O \${FILES}";
        pamgrep = "!sh -c 'FILES=`git grep -l -A 0 -B 0 $1 $2 | fzf -x -m` && nvim -O `echo \${FILES} | cut -d':' -f1 | xargs`' -";
        pamvimlog = "!HASH=`git log --pretty=oneline | head -n 50 | fzf` && HASHZ=`echo \${HASH} | awk '{ print $1 }'` && FILES=`git show --diff-filter=d --pretty='format:' --name-only $HASHZ | grep -v -e '^$' | fzf -x -m` && nvim -O \${FILES}";
        pamreset = "!HASH=`git log --pretty=oneline | head -n 50 | fzf` && git reset --soft `echo \${HASH} | awk '{ print $1 }'`";
        pamresethard = "!HASH=`git log --pretty=oneline | head -n 50 | fzf` && git reset --hard `echo \${HASH} | awk '{ print $1 }'`";
      };
    };
    userEmail = mail;
    userName = name;
  };
}
