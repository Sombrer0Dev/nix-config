{ ... }:
{
  programs.nixvim.plugins.oil = {
    enable = true;
    settings = {
      default_file_explorer = true;
      view_options.show_hidden = true;
      win_options.signcolumn = "yes:2";
    };
  };

  programs.nixvim.plugins.oil-git-status.enable = true;

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "-";
      action = "<cmd>Oil<CR>";
      options.desc = "Open parent directory";
    }
  ];
}
