-- ============================================================================
-- Language-specific highlight overrides
-- ============================================================================

local p = require("vagari.palette")
local h = require("vagari.helpers")
local hl = h.hl
local link = h.link

local languages = {}

-- stylua: ignore start
function languages.setup()

	-- Bash
	hl("@variable.parameter.bash",   { fg = p.blu_3 })
	hl("@variable.builtin.bash",     { fg = p.rby_3 })
	hl("@keyword.directive.bash",    { fg = p.emr_2 })

	-- TOML
	link("@type.toml", "Tag")
	link("@property.toml", "VariableParameter")

	-- Lua
	hl("@property.lua", { fg = p.blu_3 })

	-- Help
	link("@label.help", "Tag")

end
-- stylua: ignore end

return languages
