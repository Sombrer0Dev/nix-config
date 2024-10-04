return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  enabled = not vim.g.started_by_firenvim,
  dependencies = {
    "SmiteshP/nvim-navic",
  },
  opts = {
    -- configurations go here
    exclude_filetypes = { "netrw", "toggleterm" },
  },
}
