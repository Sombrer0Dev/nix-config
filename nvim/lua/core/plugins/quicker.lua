return {
  'stevearc/quicker.nvim',
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
  config = function ()
    require("quicker").setup()
  end
}
