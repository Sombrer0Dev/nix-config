local M = {
  'ggandor/leap.nvim',
  dependencies = { 'tpope/vim-repeat' },
  config = function()
    vim.keymap.set('n', 's', '<Plug>(leap)')
    vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
    vim.keymap.set({ 'x', 'o' }, 's', '<Plug>(leap-forward)')
    vim.keymap.set({ 'x', 'o' }, 'S', '<Plug>(leap-backward)')
  end,
}

vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })

return M
