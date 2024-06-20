let
  name = "Artem Sokolov";
  username = "Sombrer0Dev";
  mail = "sombrer01@gmail.com";
in {
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = username;
      push.autoSetupRemote = true;
    };
    userEmail = mail;
    userName = name;
  };
}
