{ ... }:
{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
      autoLoad = true;
    };

    plugins.dap-python = {
      enable = true;
      autoLoad = true;
      customConfigurations = [
        {
          name = "Launch current file";
          type = "python";
          request = "launch";
          program.__raw = "vim.fn.expand('%')";
          cwd.__raw = "vim.fn.getcwd()";
        }
      ];
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
      options.desc = "Add breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dB";
      action = "<cmd>lua require('dap').list_breakpoints()<CR>";
      options.desc = "See breakpoints";
    }
    {
      mode = "n";
      key = "<leader>di";
      action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
      options.desc = "Add conditional breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dr";
      action = "<cmd>lua require('dap').continue()<CR>";
      options.desc = "Run debug";
    }
  ];
}
