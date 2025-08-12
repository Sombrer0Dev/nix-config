return {
	"lualine.nvim",
	enabled = nixCats("general") or false,
	-- cmd = { "" },
	event = "DeferredUIEnter",
	-- ft = "",
	-- keys = "",
	-- colorscheme = "",
	load = function(name)
		vim.cmd.packadd(name)
	end,
	after = function(plugin)
		local utils = require("utils.functions")
		require("lualine").setup({
			options = {
				component_separators = { left = " ", right = " " },
				section_separators = { left = " ", right = " " },
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						icon = "",
						fmt = function(mode)
							return mode:lower()
						end,
					},
				},
				lualine_b = { { "branch", icon = "" } },
				lualine_c = {
					{
						"diagnostics",
						symbols = {
							error = " ",
							warn = " ",
							info = " ",
							hint = "󰝶 ",
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 0, right = 0 } },
					{ "filename", path = 1, padding = { left = 0, right = 0 } },
					{
						function()
							local buffer_count = utils.get_buffer_count()

							return "+" .. buffer_count - 1 .. " "
						end,
						cond = function()
							return utils.get_buffer_count() > 1
						end,
						color = utils.get_hlgroup("Operator", nil),
						padding = { left = 0, right = 1 },
					},
					{
						function()
							local tab_count = vim.fn.tabpagenr("$")
							if tab_count > 1 then
								return vim.fn.tabpagenr() .. " of " .. tab_count
							end
						end,
						cond = function()
							return vim.fn.tabpagenr("$") > 1
						end,
						icon = "󰓩",
						color = utils.get_hlgroup("Special", nil),
					},
				},
				lualine_x = {
					-- {
					--     function()
					--         local icon = " "
					--         local status = require("copilot.api").status.data
					--         return icon .. (status.message or "")
					--     end,
					--     cond = function()
					--         local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
					--         return ok and #clients > 0
					--     end,
					--     color = function()
					--         if not package.loaded["copilot"] then
					--             return
					--         end
					--         local status = require("copilot.api").status.data
					--         return copilot_colors[status.status] or copilot_colors[""]
					--     end,
					-- },
					{ "diff" },
				},
				lualine_y = {
					{
						"progress",
					},
					{
						"location",
						color = utils.get_hlgroup("Boolean"),
					},
				},
				lualine_z = {
					{
						function()
							local reg = vim.fn.reg_recording()
							if reg == "" then
								return ""
							end -- not recording
							return "recording to " .. reg
						end,
						icon = "",
						color = utils.get_hlgroup("Special", nil),
					},
				},
			},
		})
	end,
}
