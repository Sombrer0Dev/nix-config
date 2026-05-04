{ ... }:
{
  programs.nixvim.plugins.smart-splits = {
    enable = true;
    settings = {};
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<A-h>";
      action = "<cmd>lua require('smart-splits').move_cursor_left()<CR>";
    }
    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>lua require('smart-splits').move_cursor_down()<CR>";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>lua require('smart-splits').move_cursor_up()<CR>";
    }
    {
      mode = "n";
      key = "<A-l>";
      action = "<cmd>lua require('smart-splits').move_cursor_right()<CR>";
    }

    {
      mode = "n";
      key = "<A-S-h>";
      action = "<cmd>lua require('smart-splits').resize_left()<CR>";
    }
    {
      mode = "n";
      key = "<A-S-j>";
      action = "<cmd>lua require('smart-splits').resize_down()<CR>";
    }
    {
      mode = "n";
      key = "<A-S-k>";
      action = "<cmd>lua require('smart-splits').resize_up()<CR>";
    }
    {
      mode = "n";
      key = "<A-S-l>";
      action = "<cmd>lua require('smart-splits').resize_right()<CR>";
    }
  ];
}
