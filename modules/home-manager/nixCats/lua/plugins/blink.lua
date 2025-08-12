return {
	{
		"friendly-snippets",
		dep_of = "blink.cmp",
		enabled = nixCats("general") or false,
	},
	{
		"blink-ripgrep.nvim",
		dep_of = "blink.cmp",
		enabled = nixCats("general") or false,
	},
	{
		"LuaSnip",
		dep_of = "blink.cmp",
		enabled = nixCats("general") or false,
	},
	-- {
	-- 	"blink-cmp-tmux",
	-- 	dep_of = "blink.cmp",
	-- 	enabled = nixCats("general") or false,
	-- },
	{
		"blink.cmp",
		enabled = nixCats("general") or false,
		event = "DeferredUIEnter",
		on_require = "blink",
		after = function(plugin)
			require("blink.cmp").setup({
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- See :h blink-cmp-config-keymap for configuring keymaps
				keymap = {
					preset = "default",
					["<Tab>"] = {},
				},
				appearance = {
					nerd_font_variant = "mono",
				},
				signature = { enabled = true },
				completion = {
					ghost_text = { enabled = false },
					menu = {
						border = "single",
						draw = {
							columns = {
								{ "label", "label_description", gap = 1 },
								{ "kind_icon", "kind" },
							},
						},
					},
					documentation = {
						window = { border = "single" },
						auto_show = true,
						auto_show_delay_ms = 500,
					},
				},
				sources = {
					default = {
						-- "lazydev",
						"lsp",
						"path",
						"snippets",
						"buffer",
						"ripgrep",
						-- "tmux",
					},
					providers = {
						ripgrep = {
							module = "blink-ripgrep",
							name = "Ripgrep",
							-- the options below are optional, some default values are shown
							---@module "blink-ripgrep"
							---@type blink-ripgrep.Options
							opts = {
								-- For many options, see `rg --help` for an exact description of
								-- the values that ripgrep expects.

								-- the minimum length of the current word to start searching
								-- (if the word is shorter than this, the search will not start)
								prefix_min_len = 5,

								backend = {
									context_size = 5,
									additional_rg_options = {},
									max_filesize = "1M",
									search_casing = "--smart-case",
								},

								-- Specifies how to find the root of the project where the ripgrep
								-- search will start from. Accepts the same options as the marker
								-- given to `:h vim.fs.root()` which offers many possibilities for
								-- configuration. If none can be found, defaults to Neovim's cwd.
								--
								-- Examples:
								-- - ".git" (default)
								-- - { ".git", "package.json", ".root" }
								project_root_marker = { ".git", "package.json", "requirements.txt" },

								-- When a result is found for a file whose filetype does not have a
								-- treesitter parser installed, fall back to regex based highlighting
								-- that is bundled in Neovim.
								fallback_to_regex_highlighting = true,

								score_offset = -100,
							},
						},
						tmux = {
							module = "blink-cmp-tmux",
							name = "tmux",
							-- default options
							opts = {
								all_panes = false,
								capture_history = false,
								-- only suggest completions from `tmux` if the `trigger_chars` are
								-- used
								triggered_only = false,
								trigger_chars = { "." },
							},
						},
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
						},
					},
				},
			})
		end,
	},
}
