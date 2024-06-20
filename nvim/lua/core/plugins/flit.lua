return {
  'ggandor/flit.nvim',
  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    require('flit').setup {
      multiline = false,
    }
  end,
}
