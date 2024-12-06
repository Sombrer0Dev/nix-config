vim.api.nvim_create_autocmd({'UIEnter'}, {
  callback = function(event)
    local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
    if client ~= nil and client.name == "Firenvim" then
      vim.g.firenvim_config.localSettings['.*'] = { takeover = 'always' }
    end
  end
})

if vim.g.started_by_firenvim == true then
  vim.o.laststatus = 0
else
  vim.o.laststatus = 3
end
