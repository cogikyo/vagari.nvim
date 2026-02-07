-- ============================================================================
-- Language-specific highlight overrides
-- ============================================================================

local p = require("vagari.palette")

local languages = {}

local function hl(name, def)
	local result = {}
	if def.fg then result.fg = def.fg end
	if def.bg then result.bg = def.bg end
	vim.api.nvim_set_hl(0, name, result)
end

local function link(name, target)
	vim.api.nvim_set_hl(0, name, { link = target })
end

-- stylua: ignore start
function languages.setup()

	-- Bash
	hl("@variable.parameter.bash",   { fg = p.blu_3 })
	hl("@variable.builtin.bash",     { fg = p.rby_3 })
	hl("@keyword.directive.bash",    { fg = p.emr_2 })

	-- TOML
	link("@type.toml", "Tag")
	link("@property.toml", "VariableParameter")

	-- Help
	link("@label.help", "Tag")

end
-- stylua: ignore end

return languages
