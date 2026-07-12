{ ... }:
{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>lua vim.diagnostic.open_float(nil, { scope = 'cursor' })<CR>";
      options.desc = "Preview error";
    }
  ];
}
