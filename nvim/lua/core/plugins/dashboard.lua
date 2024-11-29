local M = {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  opts = function()
    local opts = {
      theme = 'doom',
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = require('core.plugins.logos.good').bloody,
        -- header = require('core.plugins.logos.bad').amogus,
        -- stylua: ignore
        center = {
          { action = 'FzfLua files formatter="path.filename_first"', key = "f", desc = ""},
          { action = function()
            vim.cmd "cd ~/Work"
            require("core.plugins.fzf.pickers").folders({max_depth=2, proj=true})
          end, key = "p", desc = ""},
          { action = "e $MYVIMRC | cd %:p:h | wincmd k | pwd",  key = "s", desc = ""},
          { action = require("core.plugins.fzf.pickers").grep,  key = "g", desc = ""},
          { action = require("core.plugins.fzf.pickers").universal_worktree,  key = "w", desc = ""},
          { action = "qa",                                      key = "q", desc = ""},
        },
        footer = {},
        -- footer = function()
        --   local stats = require('lazy').stats()
        --   local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        --   return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
        -- end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
      button.key_format = '  %s'
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'DashboardLoaded',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#E7516A' })
    vim.keymap.set("n", "<leader>md", "<cmd>Dashboard<cr>")

    return opts
  end,
}
return M
