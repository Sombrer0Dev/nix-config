local _map = function(mode, keys, func, desc)
	if desc then
		desc = "LSP: " .. desc
	end
	vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
end
local function lsp_on_attach(_, bufnr)
	-- we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.

	local nmap = function(keys, func, desc)
		_map("n", keys, func, desc)
	end
	local nvmap = function(keys, func, desc)
		_map({ "n", "v" }, keys, func, desc)
	end

	nmap("<leader>lr", vim.lsp.buf.rename, "Rename")
	nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")
	nmap("<leader>li", "<cmd>LspInfo<cr>", "Code Action")
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	if nixCats("general") then
		nmap("<leader>ld", "<cmd>FzfLua lsp_definitions<cr>", "Definition")
		nmap("<leader>lr", "<cmd>FzfLua lsp_references<cr>", "References")
		nmap("<leader>lt", "<cmd>FzfLua lsp_typedefs<cr>", "Type Definition")
		nmap("<leader>li", "<cmd>FzfLua lsp_implementations<cr>", "Implementation")
		nmap("<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", "Document Symbols")
		nmap("<leader>le", "<cmd>FzfLua diagnostics_document<cr>", "Document Diagnostics")
		nvmap("gd", "<CMD>FzfLua lsp_definitions<CR>", "Fzf definitions")
		nvmap("gD", "<CMD>FzfLua lsp_references<CR>", "Fzf references")
		nvmap("gT", "<CMD>FzfLua lsp_typedefs<CR>", "Fzf type definitions")
		nvmap("gM", "<CMD>FzfLua lsp_implementations<CR>", "Fzf implementations")
	end

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- NOTE: Register a handler from lzextras. This one makes it so that
-- you can set up lsps within lze specs,
-- and trigger vim.lsp.enable and the rtp config collection only on the correct filetypes
-- it adds the lsp field used below
-- (and must be registered before any load calls that use it!)
require("lze").register_handlers(require("lzextras").lsp)
-- also replace the fallback filetype list retrieval function with a slightly faster one
require("lze").h.lsp.set_ft_fallback(function(name)
	return dofile(nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" }) .. "/lsp/" .. name .. ".lua").filetypes
		or {}
end)
require("lze").load({
	{
		"nvim-lspconfig",
		enabled = nixCats("general") or false,
		-- the on require handler will be needed here if you want to use the
		-- fallback method of getting filetypes if you don't provide any
		on_require = { "lspconfig" },
		-- define a function to run over all type(plugin.lsp) == table
		-- when their filetype trigger loads them
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
		end,
		before = function(_)
			vim.lsp.config("*", {
				on_attach = lsp_on_attach,
			})
		end,
	},
	{
		-- name of the lsp
		"lua_ls",
		enabled = nixCats("lua") or false,
		-- provide a table containing filetypes,
		-- and then whatever your functions defined in the function type specs expect.
		-- in our case, it just expects the normal lspconfig setup options.
		lsp = {
			-- if you provide the filetypes it doesn't ask lspconfig for the filetypes
			filetypes = { "lua" },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					formatters = {
						ignoreComments = true,
					},
					signatureHelp = { enabled = true },
					diagnostics = {
						globals = { "nixCats", "vim" },
						disable = { "missing-fields" },
					},
					telemetry = { enabled = false },
				},
			},
		},
		-- also these are regular specs and you can use before and after and all the other normal fields
	},
	{
		"gopls",
		enabled = nixCats("go") or false,
		-- if you don't provide the filetypes it asks lspconfig for them using the function we set above
		lsp = {
			-- filetypes = { "go", "gomod", "gowork", "gotmpl" },
		},
	},
	{
		"jedi-language-server",
		enabled = nixCats("py") or false,
		-- if you don't provide the filetypes it asks lspconfig for them using the function we set above
		lsp = {
			-- filetypes = { "go", "gomod", "gowork", "gotmpl" },
		},
	},
	{
		"ruff",
		enabled = nixCats("py") or false,
		-- if you don't provide the filetypes it asks lspconfig for them using the function we set above
		lsp = {
			-- filetypes = { "go", "gomod", "gowork", "gotmpl" },
		},
	},
	{
		"nixd",
		enabled = nixCats("nix") or false,
		lsp = {
			filetypes = { "nix" },
			settings = {
				nixd = {
					-- nixd requires some configuration.
					-- luckily, the nixCats plugin is here to pass whatever we need!
					-- we passed this in via the `extra` table in our packageDefinitions
					-- for additional configuration options, refer to:
					-- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
					nixpkgs = {
						-- in the extras set of your package definition:
						-- nixdExtras.nixpkgs = ''import ${pkgs.path} {}''
						expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
					},
					options = {
						nixos = {
							-- nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").nixosConfigurations.configname.options''
							expr = nixCats.extra("nixdExtras.nixos_options"),
						},
						["home-manager"] = {
							-- nixdExtras.home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").homeConfigurations.configname.options''
							expr = nixCats.extra("nixdExtras.home_manager_options"),
						},
					},
					formatting = {
						command = { "alejandra" },
					},
					diagnostic = {
						suppress = {
							"sema-escaping-with",
						},
					},
				},
			},
		},
	},
})
