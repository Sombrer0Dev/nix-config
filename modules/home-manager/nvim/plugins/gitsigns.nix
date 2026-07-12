{ ... }:
{
  programs.nixvim.plugins.gitsigns.enable = true;

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "]g";
      action = "<cmd>lua require('gitsigns').next_hunk()<CR>";
      options.desc = "Next git hunk";
    }
    {
      mode = "n";
      key = "[g";
      action = "<cmd>lua require('gitsigns').prev_hunk()<CR>";
      options.desc = "Previous git hunk";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>";
      options.desc = "Toggle line blame";
    }
    {
      mode = "n";
      key = "<leader>gB";
      action = "<cmd>lua require('gitsigns').blame_line({ full = true })<CR>";
      options.desc = "Blame full file";
    }
    {
      mode = "n";
      key = "<leader>ge";
      action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
      options.desc = "Preview git hunk";
    }
  ];
}
