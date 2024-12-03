local M = {
  'ggandor/leap.nvim',
  dependencies = { 'tpope/vim-repeat' },
  config = function()
    vim.keymap.set('n', '<CR>', '<Plug>(leap)')
  end,
}


return M
