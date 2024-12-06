local api = vim.api
local oil = require 'oil'

api.nvim_create_user_command('OilFm', function()
  oil.setup {
    keymaps = {
      ['<C-f>'] = function()
        require('core.plugins.fzf.pickers').folders { cwd = oil.get_current_dir() }
      end,
      ['<C-z>'] = require('core.plugins.fzf.pickers').zoxide,
      ['gd'] = function()
        local entry = oil.get_cursor_entry()
        if entry.type == 'directory' then
          vim.notify 'cant drag dir'
          return
        end
        local path = oil.get_current_dir()

        local target = path .. entry.name
        vim.fn.system('dragon-drop ' .. target)
      end,
      ['gD'] = function()
        local output = vim.fn.system 'dragon-drop --print-path --target'
        for _, path in ipairs(vim.split(output, '\n')) do
          if path == '' then
            goto continue
          end
          local p_path = vim.fn.system('printf "%s" "' .. path .. '" | grep "^(https?|ftps?|s?ftp)://"')
          if p_path ~= '' then
            vim.notify 'not implemented to add remote file'
            return
          end
          local cwd = oil.get_current_dir()
          local filename = vim.fs.basename(path)
          local cmd = 'cp ' .. path .. ' ' .. cwd .. filename
          vim.fn.system(cmd)

          ::continue::
        end
      end,
    },
  }
  oil.open(nil)
end, {})
