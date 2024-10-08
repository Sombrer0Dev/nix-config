return {
  'kawre/leetcode.nvim',
  cmd = 'Leet',
  build = ':TSUpdate html',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',

    -- optional
    'nvim-treesitter/nvim-treesitter',
    'rcarriga/nvim-notify',
  },
  opts = {
    lang = 'golang',
  },
}
