local conf = vim.g.config
local utils = require("core.plugins.lsp.utils")
local lsp_settings = require("core.plugins.lsp.settings")

local capabilities = vim.lsp.protocol.make_client_capabilities()
local vlsp = vim.lsp
-- -- enable autocompletion
if vim.g.config.plugins.blink.enable then
	capabilities = require("blink.cmp").get_lsp_capabilities()
else
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end

-- NVIM UFO
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

require("utils.functions").on_attach(function(client, buffer)
	require("core.plugins.lsp.keys").on_attach(client, buffer)
	if client.name == "ruff_lsp" then
		client.server_capabilities.hoverProvider = false
	elseif client.name == "jedi_language_server" then
		client.server_capabilities.codeActionProvider = { codeActionKinds = { "refactor.inline" } }
	end
end)

for _, lsp in ipairs(conf.lsp_servers) do
	vim.lsp.enable(lsp)
	-- nvim_lsp[lsp].setup({
	-- 	capabilities = capabilities,
	-- 	flags = { debounce_text_changes = 150 },
	-- 	root_dir = root_dir_options(lsp),
	-- 	single_file_support = false,
	-- 	settings = {
	-- 		json = lsp_settings.json,
	-- 		Lua = lsp_settings.lua,
	-- 		yaml = lsp_settings.yaml,
	-- 		gopls = lsp_settings.gopls,
	-- 		jedi_language_server = lsp_settings.jedi,
	-- 		pylsp = lsp_settings.pylsp,
	-- 		pylyzer = lsp_settings.pylyzer,
	-- 		ruff_lsp = lsp_settings.ruff,
	-- 		sqlls = lsp_settings.sqlls,
	-- 		tailwindcss = lsp_settings.tailwindcss,
	-- 		html = lsp_settings.html,
	-- 		htmx = lsp_settings.htmx,
	-- 		basedpyright = lsp_settings.basedpyright,
	-- 		dockerls = lsp_settings.dockerls,
	-- 		nix_ls = lsp_settings.nix_ls,
	-- 		ts_ls = lsp_settings.ts_ls,
	-- 	},
	-- })
end
vim.lsp.config("jedi_language_server", lsp_settings.jedi)
vim.lsp.config("clangd", lsp_settings.clangd)
vim.lsp.config("json", lsp_settings.json)
vim.lsp.config("yaml", lsp_settings.yaml)

-- vlsp.handlers["textDocument/publishDiagnostics"] = vlsp.with(vlsp.diagnostic.on_publish_diagnostics, {
-- 	underline = false,
-- })

vim.diagnostic.config({
	update_in_insert = true,
})
