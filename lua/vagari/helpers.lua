-- ============================================================================
-- Vagari Helpers
-- Shared highlight utility functions
-- ============================================================================

local M = {}

-- Convert thalamus format to nvim_set_hl format
-- thalamus uses: { fg, bg, sp, fmt } where fmt = "bold,italic"
-- nvim_set_hl expects: { fg, bg, sp, bold = true, italic = true }
local function convert(def)
	if not def or type(def) ~= "table" then
		return {}
	end
	local result = {}
	if def.fg then
		result.fg = def.fg
	end
	if def.bg then
		result.bg = def.bg
	end
	if def.sp then
		result.sp = def.sp
	end
	if def.fmt and type(def.fmt) == "string" then
		for attr in def.fmt:gmatch("[^,]+") do
			result[attr] = true
		end
	end
	return result
end

function M.hl(name, val)
	vim.api.nvim_set_hl(0, name, convert(val))
end

function M.link(name, target)
	vim.api.nvim_set_hl(0, name, { link = target })
end

return M
