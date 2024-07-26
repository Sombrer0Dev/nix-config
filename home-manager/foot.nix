{ pkgs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      font="MonaspiceKr Nerd Font:size=11";
      font-bold="MonaspiceKr Nerd Font:size=11";
      font-italic="MonaspiceXe Nerd Font:size=11";
      font-bold-italic="MonaspiceXe Nerd Font:size=11";
    };
  };
}

