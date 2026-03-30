-- Neovim plugin: vim API, metatables, closures, module pattern, autocmds.

local api = vim.api
local fn = vim.fn
local keymap = vim.keymap

---@class vagari.Picker
---@field items string[]
---@field buf integer
---@field win integer
---@field on_select fun(item: string)
local Picker = {}
Picker.__index = Picker

---@param items string[]
---@param opts? { title?: string, on_select?: fun(item: string) }
---@return vagari.Picker
function Picker.new(items, opts)
	opts = opts or {}
	local self = setmetatable({
		items = items,
		buf = -1,
		win = -1,
		on_select = opts.on_select or function(item)
			vim.notify("Selected: " .. item, vim.log.levels.INFO)
		end,
	}, Picker)

	self:_create_window(opts.title or "Picker")
	return self
end

function Picker:_create_window(title)
	self.buf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_lines(self.buf, 0, -1, false, self.items)

	-- Calculate window dimensions
	local width = math.max(40, math.max(unpack(
		vim.tbl_map(function(s) return #s end, self.items)
	)) + 4)
	local height = math.min(#self.items, 20)

	local ui = api.nvim_list_uis()[1]
	local row = math.floor((ui.height - height) / 2)
	local col = math.floor((ui.width - width) / 2)

	self.win = api.nvim_open_win(self.buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		title = " " .. title .. " ",
		title_pos = "center",
	})

	-- Buffer options
	vim.bo[self.buf].modifiable = false
	vim.bo[self.buf].bufhidden = "wipe"
	vim.wo[self.win].cursorline = true
	vim.wo[self.win].winblend = 10

	self:_setup_keymaps()
	self:_setup_autocmds()
end

function Picker:_setup_keymaps()
	local close = function() self:close() end
	local confirm = function()
		local idx = api.nvim_win_get_cursor(self.win)[1]
		local item = self.items[idx]
		self:close()
		if item then
			self.on_select(item)
		end
	end

	local map_opts = { buffer = self.buf, nowait = true }
	keymap.set("n", "q", close, map_opts)
	keymap.set("n", "<Esc>", close, map_opts)
	keymap.set("n", "<CR>", confirm, map_opts)
end

function Picker:_setup_autocmds()
	local group = api.nvim_create_augroup("VagariPicker", { clear = true })

	api.nvim_create_autocmd("BufLeave", {
		group = group,
		buffer = self.buf,
		callback = function()
			self:close()
		end,
	})

	api.nvim_create_autocmd("VimResized", {
		group = group,
		callback = function()
			if api.nvim_win_is_valid(self.win) then
				local ui = api.nvim_list_uis()[1]
				local config = api.nvim_win_get_config(self.win)
				config.row = math.floor((ui.height - config.height) / 2)
				config.col = math.floor((ui.width - config.width) / 2)
				api.nvim_win_set_config(self.win, config)
			end
		end,
	})
end

function Picker:close()
	if self.win ~= -1 and api.nvim_win_is_valid(self.win) then
		api.nvim_win_close(self.win, true)
	end
	self.win = -1
end

-- Module setup with user commands
local M = {}

function M.setup(opts)
	opts = vim.tbl_deep_extend("force", {
		border = "rounded",
		max_height = 20,
	}, opts or {})

	api.nvim_create_user_command("VagariPick", function(cmd)
		local items = vim.split(cmd.args, ",")
		items = vim.tbl_filter(function(s) return s ~= "" end, items)

		if #items == 0 then
			-- Default: pick from open buffers
			items = vim.tbl_map(
				function(b) return fn.bufname(b) end,
				vim.tbl_filter(
					function(b) return api.nvim_buf_is_loaded(b) and fn.buflisted(b) == 1 end,
					api.nvim_list_bufs()
				)
			)
		end

		Picker.new(items, { title = "Pick", on_select = function(item)
			vim.cmd.edit(item)
		end })
	end, {
		nargs = "?",
		desc = "Open the Vagari picker",
		complete = function()
			return vim.tbl_map(fn.bufname, api.nvim_list_bufs())
		end,
	})
end

return M
