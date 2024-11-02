return {
  {
    "pytest.nvim",
    dir = "/home/arsokolov/Work/pytest.nvim",
    lazy = false,
    opts = {},
    dependencies = {
    "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>rb",
        "<cmd>Lazy reload pytest.nvim<cr>",
        desc = "Reload pytest.nvim",
        mode = { "n", "v" },
      },
      {
        "<leader>rp",
        "<cmd>Pytest fixtures<cr>",
        desc = "Pytest fixtures",
        mode = { "n", "v" },
      },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "${3rd}/luassert/library",
        "${3rd}/busted/library",
        "nvim-lua/plenary.nvim",
        "pytest.nvim",
      }
    },
  },
}
