{ ... }:
{
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    comment = "Edit text files in Neovim";
    icon = "nvim";
    exec = "ghostty -e nvim %F";
    terminal = false;
    type = "Application";
    categories = [ "Utility" "TextEditor" ];
    mimeType = [
      "text/plain"
      "text/x-makefile"
      "text/x-c"
      "text/x-c++"
      "text/x-python"
      "text/x-shellscript"
      "application/x-shellscript"
      "text/x-nix"
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = "nvim.desktop";
    "text/x-makefile" = "nvim.desktop";
    "text/x-c" = "nvim.desktop";
    "text/x-c++" = "nvim.desktop";
    "text/x-python" = "nvim.desktop";
    "text/x-shellscript" = "nvim.desktop";
    "application/x-shellscript" = "nvim.desktop";
    "text/x-nix" = "nvim.desktop";
  };

  programs.ghostty = {
    enable = true;
    settings = {
      command = "tmux new-session -A -s nix";

      confirm-close-surface = false;

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
