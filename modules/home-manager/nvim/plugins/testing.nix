{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.neotest = {
      enable = true;
      autoLoad = true;
      callSetup = false;
    };

    extraPlugins = with pkgs.vimPlugins; [
      neotest-python
    ];

    extraConfigLua = ''
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = {
              justMyCode = false,
            },
          }),
        },
      })
    '';
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>tr";
      action = "<cmd>lua require('neotest').run.run()<CR>";
      options.desc = "Run tests";
    }
  ];
}
