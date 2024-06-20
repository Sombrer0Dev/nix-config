return {
  {
    'vhyrro/luarocks.nvim',
    enabled = false,
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { 'magick' },
    },
  },
  {
    '3rd/image.nvim',
    dependencies = { 'luarocks.nvim' },
    enabled = false,
    config = function()
      require('image').setup {
        -- backend = 'ueberzug',
        backend = 'kitty',
      }
    end,
  },
}
