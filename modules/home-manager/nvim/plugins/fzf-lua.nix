{ ... }:
{
  programs.nixvim.plugins.fzf-lua = {
    enable = true;
    profile = "fzf-tmux";
    settings.files.formatter = "path.filename_first";
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>f";
      action = "<nop>";
      options.desc = "Find";
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>FzfLua files<CR>";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>FzfLua live_grep<CR>";
      options.desc = "Live grep";
    }
    {
      mode = "n";
      key = "<leader>fw";
      action = "<cmd>FzfLua grep_cword<CR>";
      options.desc = "Grep word";
    }
  ];
}
