local M = {}

local function find_block_bounds()
	local cursor = vim.api.nvim_win_get_cursor(0)[1]
	local start_line
	local start_indent

	for lnum = cursor, 1, -1 do
		local line = vim.fn.getline(lnum)
		local indent = line:match("^(%s*)[%w_]+%s*=%s*{%s*$")
		if indent then
			start_line = lnum
			start_indent = indent
			break
		end
	end

	if not start_line then
		return nil, nil
	end

	for lnum = start_line + 1, vim.api.nvim_buf_line_count(0) do
		local line = vim.fn.getline(lnum)
		if line:match("^" .. start_indent .. "},?%s*$") then
			return start_line, lnum
		end
	end

	return nil, nil
end

local function align_comments(start_line, end_line)
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local parsed = {}
	local max_width = 0

	for index, line in ipairs(lines) do
		local before, comment = line:match("^(.-)%s*(%-%-.*)$")
		if before and before:match("%S") then
			before = before:gsub("%s+$", "")
			parsed[index] = { before = before, comment = comment }
			max_width = math.max(max_width, vim.fn.strdisplaywidth(before))
		end
	end

	for index, item in pairs(parsed) do
		local padding = max_width - vim.fn.strdisplaywidth(item.before) + 2
		lines[index] = item.before .. string.rep(" ", padding) .. item.comment
	end

	vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end

local function align_current_block()
	local start_line, end_line = find_block_bounds()
	if not start_line then
		vim.notify("No Vagari table block found", vim.log.levels.WARN)
		return
	end

	align_comments(start_line, end_line)
end

local function set_keymap(buf)
	vim.keymap.set("n", "<leader>gic", align_current_block, {
		buffer = buf,
		desc = "Align Vagari inline comments",
	})
end

function M.setup()
	local group = vim.api.nvim_create_augroup("VagariEditing", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
		group = group,
		pattern = "*/lua/vagari/thalamus.lua",
		callback = function(event)
			set_keymap(event.buf)
		end,
	})

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local loaded = vim.api.nvim_buf_is_loaded(buf)
		local is_thalamus = vim.api.nvim_buf_get_name(buf):match("/lua/vagari/thalamus%.lua$")

		if loaded and is_thalamus then
			set_keymap(buf)
		end
	end
end

return M
