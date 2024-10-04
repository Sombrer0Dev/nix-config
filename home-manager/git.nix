let
  name = "Artem Sokolov";
  username = "arsokolov";
  mail = "arsokolov@ptsecurity.com";
in
{
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = username;
      push.autoSetupRemote = true;

      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
    userEmail = mail;
    userName = name;
    aliases = { };
  };
}
