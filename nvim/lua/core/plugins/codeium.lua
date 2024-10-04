local codeium = vim.g.config.plugins.ai.codeium.enabled
local vt = vim.g.config.plugins.ai.codeium.vt

if not codeium then
  return {}
end

return {
  {
    'Exafunction/codeium.nvim',
    enabled = not vt,
    event = 'InsertEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup {}
    end,
  },
  {
    'Exafunction/codeium.vim',
    enabled = vt,
    -- event = 'InsertEnter',
    config = function()
      vim.g.codeium_disable_bindings = 1

      vim.keymap.set('i', '<C-g>', function()
        return vim.fn['codeium#Accept']()
      end, { expr = true, silent = true })

      vim.keymap.set('i', '<c-;>', function()
        return vim.fn['codeium#CycleCompletions'](1)
      end, { expr = true, silent = true })

      vim.keymap.set('i', '<c-,>', function()
        return vim.fn['codeium#CycleCompletions'](-1)
      end, { expr = true, silent = true })

      vim.keymap.set('i', '<c-x>', function()
        return vim.fn['codeium#Clear']()
      end, { expr = true, silent = true })
    end,
  },
}
