local M = {
  'karb94/neoscroll.nvim',
  enabled = false,
  config = function()
    local neoscroll = require 'neoscroll'
    local easing = 'sine'
    local zz_time_ms = 100
    local jump_time_ms = 200

    neoscroll.setup {
      -- All these keys will be mapped to their corresponding default scrolling animation
      mappings = { '<C-u>', '<C-d>', 'zz' },
      hide_cursor = true, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      easing_function = nil, -- Default easing function
      pre_hook = nil, -- Function to run before the scrolling animation starts
      post_hook = function(info)
        if info ~= 'center' then
          return
        end

        -- The `defer_fn` is a bit of a hack.
        -- We use it so that `neoscroll.init.scroll` will be false when we call `neoscroll.zz`
        -- As long as we don't input another neoscroll mapping in the timeout,
        -- we should be able to center the cursor.
        local defer_time_ms = 10
        vim.defer_fn(function()
          neoscroll.zz(zz_time_ms, easing)
        end, defer_time_ms)
      end,
      performance_mode = false, -- Disable "Performance Mode" on all buffers.
    }
  end
}

return M
