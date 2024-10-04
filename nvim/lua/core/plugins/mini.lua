return {

	{
		"echasnovski/mini.comment",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		-- is not loaded without explicitly saying it
		config = true,
	},
	{
		"echasnovski/mini.icons",
		version = false,
		config = function()
			MiniIcons = require("mini.icons")
			MiniIcons.setup()
			MiniIcons.mock_nvim_web_devicons()
		end,
	},
	{
		"echasnovski/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "gs", -- Add surrounding in Normal and Visual modes
					delete = "gsd", -- Delete surrounding
					find = "gsf", -- Find surrounding (to the right)
					find_left = "gsF", -- Find surrounding (to the left)
					highlight = "gsh", -- Highlight surrounding
					replace = "gsc", -- Replace surrounding
					update_n_lines = "gsn", -- Update `n_lines`

					suffix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},
			})
		end,
	},
	{
		"echasnovski/mini.hipatterns",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			local hi = require("mini.hipatterns")
			return {
				highlighters = {
					-- Highlight 'FIXME', 'HACK', 'TODO', 'NOTE'
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					gogen = { pattern = "%f[%w]()go:generate()%f[%W]", group = "MiniHipatternsNote" },
					gobuild = { pattern = "%f[%w]()go:build()%f[%W]", group = "MiniHipatternsNote" },
					hex_color = hi.gen_highlighter.hex_color(),
				},
			}
		end,
	},
}
