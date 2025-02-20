local M = {}

function M.char_on_pos(pos)
	pos = pos or vim.fn.getpos(".")
	return tostring(vim.fn.getline(pos[1])):sub(pos[2], pos[2])
end

-- From: https://neovim.discourse.group/t/how-do-you-work-with-strings-with-multibyte-characters-in-lua/2437/4
function M.char_byte_count(s, i)
	if not s or s == "" then
		return 1
	end

	local char = string.byte(s, i or 1)

	-- Get byte count of unicode character (RFC 3629)
	if char > 0 and char <= 127 then
		return 1
	elseif char >= 194 and char <= 223 then
		return 2
	elseif char >= 224 and char <= 239 then
		return 3
	elseif char >= 240 and char <= 244 then
		return 4
	end
end

function M.get_visual_range()
	local sr, sc = unpack(vim.fn.getpos("v"), 2, 3)
	local er, ec = unpack(vim.fn.getpos("."), 2, 3)

	-- To correct work with non-single byte chars
	local byte_c = M.char_byte_count(M.char_on_pos({ er, ec }))
	ec = ec + (byte_c - 1)

	local range = {}

	if sr == er then
		local cols = sc >= ec and { ec, sc } or { sc, ec }
		range = { sr, cols[1] - 1, er, cols[2] }
	elseif sr > er then
		range = { er, ec - 1, sr, sc }
	else
		range = { sr, sc - 1, er, ec }
	end

	return range
end
---To display the `number` in the `statuscolumn` according to
---the `number` and `relativenumber` options and their combinations
function M.number()
	local nu = vim.opt.number:get()
	local rnu = vim.opt.relativenumber:get()
	local cur_line = vim.fn.line(".") == vim.v.lnum and vim.v.lnum or vim.v.relnum

	-- Repeats the behavior for `vim.opt.numberwidth`
	local width = vim.opt.numberwidth:get()
	local l_count_width = #tostring(vim.api.nvim_buf_line_count(0))
	-- If buffer have more lines than `vim.opt.numberwidth` then use width of line count
	width = width >= l_count_width and width or l_count_width

	local function pad_start(n)
		local len = width - #tostring(n)
		return len < 1 and n or (" "):rep(len) .. n
	end

	local v_hl = ""

	local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
	if mode == "v" then
		local v_range = M.get_visual_range()
		local is_in_range = vim.v.lnum >= v_range[1] and vim.v.lnum <= v_range[3]
		v_hl = is_in_range and "%#CursorLineNr#" or ""
	end

	if nu and rnu then
		return v_hl .. pad_start(cur_line)
	elseif nu then
		return v_hl .. pad_start(vim.v.lnum)
	elseif rnu then
		return v_hl .. pad_start(vim.v.relnum)
	end

	return ""
end

---To display pretty fold's icons in `statuscolumn` and show it according to `fillchars`
function M.foldcolumn()
	local chars = vim.opt.fillchars:get()
	local fc = "%#FoldColumn#"
	local clf = "%#CursorLineFold#"
	local hl = vim.fn.line(".") == vim.v.lnum and clf or fc
	local text = " "

	if vim.fn.foldlevel(vim.v.lnum) > vim.fn.foldlevel(vim.v.lnum - 1) then
		if vim.fn.foldclosed(vim.v.lnum) == -1 then
			text = hl .. (chars.foldopen or " ")
		else
			text = hl .. (chars.foldclose or " ")
		end
	elseif vim.fn.foldlevel(vim.v.lnum) == 0 then
		text = hl .. " "
	else
		text = hl .. (chars.foldsep or " ")
	end

	return text
end

return M
