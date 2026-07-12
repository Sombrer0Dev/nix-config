{ ... }:
{
  programs.nixvim.plugins.neogit.enable = true;

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>Neogit<CR>";
      options.desc = "Open Neogit";
    }
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>NeogitLog<CR>";
      options.desc = "Open commit log";
    }
  ];
}
