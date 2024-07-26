{ pkgs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main={
        shell="fish -c 'tmux new-session -A -s nix'";
        font="MonaspiceKr Nerd Font:size=11, UbuntuMono Nerd Font:size=12";
        font-bold="MonaspiceKr Nerd Font:size=11";
        font-italic="MonaspiceXe Nerd Font:size=11";
        font-bold-italic="MonaspiceXe Nerd Font:size=11";
      };
      colors={
        alpha=0.5;
      };
    };
  };
}

