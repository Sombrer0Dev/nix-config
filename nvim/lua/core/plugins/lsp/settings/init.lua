local M = {}

M.lua = require("core.plugins.lsp.settings.lua_ls")
M.json = require("core.plugins.lsp.settings.jsonls")
M.yaml = require("core.plugins.lsp.settings.yaml")
M.gopls = require("core.plugins.lsp.settings.gopls")
M.jedi = require("core.plugins.lsp.settings.jedi")

return M
