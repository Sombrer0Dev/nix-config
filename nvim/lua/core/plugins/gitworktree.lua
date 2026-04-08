return {
	"ThePrimeagen/git-worktree.nvim",
	config = function()
		local worktree = require("git-worktree")

		worktree.on_tree_change(function(op, metadata)
			if op == worktree.Operations.Create then
				local Path = require("plenary.path")
				local path = metadata.path

				if not Path:new(path):is_absolute() then
					path = Path:new():absolute()
					if path:sub(-#"/") == "/" then
						path = string.sub(path, 1, string.len(path) - 1)
					end
				end
				local p_path = Path:new(path)
				vim.print(vim.fn.filereadable(path..'/.envrc'))
				if vim.fn.filereadable(path .. "/.envrc") == 1 then
          path = p_path:parent().filename
				end
				local worktree_path = path .. "/" .. metadata.path .. '/'
				local share_path = path .. "/share"
				local link_share = "ln -s " .. share_path .. "/.* " .. worktree_path
				os.execute(link_share)
			end
		end)
	end,
}
