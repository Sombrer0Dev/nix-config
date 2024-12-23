local conf = vim.g.config
local nvim_lsp = require("lspconfig")
local utils = require("core.plugins.lsp.utils")
local lsp_settings = require("core.plugins.lsp.settings")

local capabilities = vim.lsp.protocol.make_client_capabilities()
local vlsp = vim.lsp
-- -- enable autocompletion via nvim-cmp
-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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

-- @param lsp string
-- @return table
local filetypes = function(lsp)
	if lsp == "html" then
		return { "html", "templ" }
	elseif lsp == "htmx" then
		return { "html", "templ" }
	elseif lsp == "tailwindcss" then
		return { "templ", "astro", "javascript", "typescript", "react" }
	end
	return nil
end

-- @param lsp string
-- @return table
local init_options = function(lsp)
	if lsp == "tailwindcss" then
		return { userLanguages = { templ = "html" } }
	end
	return nil
end

local cmd_options = function(lsp)
	if lsp == "jsonls" then
		return { "vscode-json-languageserver", "--stdio" }
	end
	return nil
end

local root_dir_options = function(lsp)
	if lsp == "denols" then
		return nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
	end
	if lsp == "ts_ls" then
		return nvim_lsp.util.root_pattern("package.json")
	end
	return nil
end

for _, lsp in ipairs(conf.lsp_servers) do
	nvim_lsp[lsp].setup({
		capabilities = capabilities,
		flags = { debounce_text_changes = 150 },
    root_dir = root_dir_options(lsp),
		-- filetypes = filetypes(lsp),
		init_options = init_options(lsp),
		cmd = cmd_options(lsp),
    single_file_support = false,
		settings = {
			json = lsp_settings.json,
			Lua = lsp_settings.lua,
			yaml = lsp_settings.yaml,
			gopls = lsp_settings.gopls,
			jedi_language_server = lsp_settings.jedi,
			pylsp = lsp_settings.pylsp,
			ruff_lsp = lsp_settings.ruff,
			sqlls = lsp_settings.sqlls,
			tailwindcss = lsp_settings.tailwindcss,
			html = lsp_settings.html,
			htmx = lsp_settings.htmx,
			basedpyright = lsp_settings.basedpyright,
			dockerls = lsp_settings.dockerls,
			nix_ls = lsp_settings.nix_ls,
			ts_ls = lsp_settings.ts_ls,
		},
	})
end

vlsp.handlers["textDocument/publishDiagnostics"] = vlsp.with(vlsp.diagnostic.on_publish_diagnostics, {
	underline = false,
})

vim.diagnostic.config({
	update_in_insert = true,
})
