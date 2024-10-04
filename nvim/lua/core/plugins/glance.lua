return {
  'dnlhc/glance.nvim',
  keys = {
    { mode = 'n', 'gd', '<CMD>Glance definitions<CR>'},
    { mode = 'n', 'gD', '<CMD>Glance references<CR>' },
    { mode = 'n', 'gT', '<CMD>Glance type_definitions<CR>' },
    { mode = 'n', 'gM', '<CMD>Glance implementations<CR>' },
  },
  config = function()
    -- Lua configuration
    local glance = require 'glance'
    local actions = glance.actions

    glance.setup {
      height = 18, -- Height of the window
      zindex = 45,

      -- By default glance will open preview "embedded" within your active window
      -- when `detached` is enabled, glance will render above all existing windows
      -- and won't be restiricted by the width of your active window
      detached = true,

      preview_win_opts = { -- Configure preview window options
        cursorline = false,
        number = false,
        relativenumber = false,
        wrap = false,
      },
      border = {
        enable = true, -- Show window borders. Only horizontal borders allowed
        top_char = '☲',
        bottom_char = '☲',
      },
      list = {
        position = 'right', -- Position of the list window 'left'|'right'
        width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
      },
      theme = { -- This feature might not work properly in nvim-0.7.2
        enable = true, -- Will generate colors for the plugin based on your current colorscheme
        mode = 'darken', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
      },
      mappings = {
        list = {
          ['j'] = actions.next, -- Bring the cursor to the next item in the list
          ['k'] = actions.previous, -- Bring the cursor to the previous item in the list
          ['<Tab>'] = false,
          ['<S-Tab>'] = false,
          ['<C-n>'] = actions.next_location,
          ['<C-p>'] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
          ['<C-u>'] = actions.preview_scroll_win(5),
          ['<C-d>'] = actions.preview_scroll_win(-5),
          ['v'] = actions.jump_vsplit,
          ['s'] = actions.jump_split,
          ['t'] = false,
          ['<CR>'] = actions.jump,
          ['o'] = actions.jump,
          ['l'] = actions.open_fold,
          ['h'] = actions.close_fold,
          ['<leader>l'] = false,
          ['q'] = actions.close,
          ['Q'] = actions.close,
          ['<Esc>'] = actions.close,
          ['<C-q>'] = actions.quickfix,
        },
      },
      hooks = {},
      folds = {
        fold_closed = '',
        fold_open = '',
        folded = false, -- Automatically fold list on startup
      },
      indent_lines = {
        enable = true,
        icon = '│',
      },
      winbar = {
        enable = true, -- Available strating from nvim-0.8+
      },
      use_trouble_qf = false, -- Quickfix action will open trouble.nvim instead of built-in quickfix list window
    }
  end,
}
