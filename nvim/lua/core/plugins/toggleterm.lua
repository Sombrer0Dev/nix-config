return {
  'akinsho/toggleterm.nvim',
  enabled = true and vim.g.neovide or false,
  version = "*",
  config = function ()

    require("toggleterm").setup{
      hide_numbers=false,
      shell="fish",
      shade_terminals = false,
      open_mapping = [[<c-/>]],
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
        return 20
      end,
    }

    require('which-key').add({
      {"<leader>t", group="Terminal"},
      {"<leader>tf", '<cmd>10ToggleTerm direction=float name=ScratchPad<cr>', desc="Float"},
      {"<leader>tt", '<cmd>1ToggleTerm direction=horizontal<cr>', desc="Float"},

      {"<leader>ft", '<cmd>TermSelect<cr>', desc="Fzf terminals"},
    })
  end
}
