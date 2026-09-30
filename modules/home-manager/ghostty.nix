{ ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      command = "tmux new-session -A -s nix";

      window-padding-x = 5;
      window-padding-y = 7;

      font-size = 11;
      font-family = "MonaspiceKr Nerd Font";
      font-family-bold = "MonaspiceKr Nerd Font";
      font-family-italic = "MonaspiceXe Nerd Font";
      font-family-bold-italic = "MonaspiceXe Nerd Font";
    };

    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
