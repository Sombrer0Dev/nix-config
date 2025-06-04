{ lib, inputs, ... }:
{
  programs.hyprpanel.settings = {
    wallpaper.image = lib.mkForce "/home/arsokolov/Documents/walls/flowers/a_group_of_flowers_on_a_black_background.png";
  };
}
