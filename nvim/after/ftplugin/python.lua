local vo = vim.opt_local
vo.tabstop = 4
vo.shiftwidth = 4
vo.softtabstop = 4

vim.keymap.set('n', "gf", require("core.plugins.fzf.pickers").fixtures, {desc="Go to fixture under cursor"})
