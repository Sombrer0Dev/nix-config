local icons = require("utils.icons")
local M = {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
	},
	-- lazy=true,
	ft = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	config = function()
		require("go").setup({
			-- NOTE: all LSP and formatting related options are disabeld.
			-- NOTE: is not related to core.plugins.lsp
			-- NOTE: manages LSP on its own
			-- go = "go", -- go command, can be go[default] or go1.18beta1
			-- goimport = "gopls", -- goimport command, can be gopls[default] or goimport
			-- fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
			-- gofmt = "gofumpt", -- gofmt cmd,
			-- max_line_len = 120, -- max line length in goline format
			-- tag_transform = false, -- tag_transfer  check gomodifytags for details
			-- test_template = "", -- default to testify if not set; g:go_nvim_tests_template  check gotests for details
			-- test_template_dir = "", -- default to nil if not set; g:go_nvim_tests_template_dir  check gotests for details
			-- comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. ﳑ       
			-- icons = { breakpoint = icons.ui.Yoga, currentpos = icons.ui.RunningMan },
			-- verbose = false, -- output loginf in messages
			lsp_cfg = true, -- true: use non-default gopls setup specified in go/lsp.lua
			-- false: do nothing
			-- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
			--   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
			-- lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
			lsp_on_attach = function(client, bufnr)
				-- attach my LSP configs keybindings
				require("core.plugins.lsp.keys").on_attach(client, bufnr)
				local wk = require("which-key")
				vim.keymap.set("n", "<leader>F", function()
					require("conform").format({ bufnr = bufnr })
				end, { desc = "Format file" })


				-- require("legendary").setup({ extensions = { which_key = { auto_register = true } } })
			end, -- nil: use on_attach function defined in go/lsp.lua,
			--      when lsp_cfg is true
			-- if lsp_on_attach is a function: use this function as on_attach function for gopls
			-- lsp_codelens = true, -- set to false to disable codelens, true by default
			lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
			-- diagnostic = {
			--   underline = false,
			--   hdlr = true, -- hook lsp diag handler
			-- virtual_text = { space = 0, prefix = icons.other.solid }, -- virtual text setup
			--   signs = true,
			-- },
			-- lsp_diag_update_in_insert = true,
			lsp_document_formatting = true,
			-- set to true: use gopls to format
			-- false if you want to use other formatter tool(e.g. efm, nulls)
			lsp_inlay_hints = {
				enable = false,
				only_current_line = true,
				style = "eol",
			},
			-- gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
			-- gopls_remote_auto = true, -- add -remote=auto to gopls
			-- gocoverage_sign = "█",
			dap_debug = false, -- set to false to disable dap
			dap_debug_keymap = false, -- true: use keymap for debugger defined in go/dap.lua
			-- false: do not use keymap in go/dap.lua.  you must define your own.
			dap_debug_gui = false, -- set to true to enable dap gui, highly recommended
			dap_debug_vt = false, -- set to true to enable dap virtual text
			luasnip = true,
			trouble = true,
		})
	end,
}

return M
