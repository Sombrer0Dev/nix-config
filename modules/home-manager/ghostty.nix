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

      theme = "cyberdream";
    };

    themes = {
      cyberdream = {
        palette = [
          # cyberdream theme for ghostty
          "0=#16181a"
          "1=#ff6e5e"
          "2=#5eff6c"
          "3=#f1ff5e"
          "4=#5ea1ff"
          "5=#bd5eff"
          "6=#5ef1ff"
          "7=#ffffff"
          "8=#3c4048"
          "9=#ff6e5e"
          "10=#5eff6c"
          "11=#f1ff5e"
          "12=#5ea1ff"
          "13=#bd5eff"
          "14=#5ef1ff"
          "15=#ffffff"
        ];
        background = "#16181a";
        foreground = "#ffffff";
        cursor-color = "#ffffff";
        selection-background = "#3c4048";
        selection-foreground = "#ffffff";
      };
    };

    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
