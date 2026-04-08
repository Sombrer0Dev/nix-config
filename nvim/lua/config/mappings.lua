local map = vim.keymap.set

map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Remap for dealing with visual line wraps
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- paste over currently selected text without yanking it
map('x', 'p', '"_dp')
map('x', 'P', '"_dP')

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Floating diagnostic' })

-- Terminal Management
map('t', '<esc>', '<c-\\><c-n>', { noremap = true })

-- LSP hover and fold preview
map('n', 'K', function()
  vim.lsp.buf.hover()
end, { desc = 'Hover doc or preview fold' })

if vim.lsp.inlay_hint then
  vim.keymap.set('n', '<leader>ci', function()
    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
  end, { desc = 'Toggle Inlay Hints' })
end
