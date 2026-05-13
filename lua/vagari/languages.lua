-- ============================================================================
-- Language-specific highlight overrides
-- ============================================================================

local p = require("vagari.palette")
local t = require("vagari.thalamus")
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

  -- Go
	hl("@module.go", { fg = p.tyr_3 })

	-- Python
	hl("@string.documentation.python", { fg = p.glc_5, fmt = "bold" })

	-- CSS
	hl("@function.css", { fg = p.orn_4 })
	hl("@keyword.directive.css", { fg = p.rby_3, fmt = "italic" })
	hl("@type.css", { fg = p.grn_4 })

	-- HTML
	hl("@character.special.html", { fg = p.glc_5, fmt = "italic" })

	-- TSX
	hl("@tag.builtin.tsx", { fg = p.blu_0 })
	hl("@tag.tsx", { fg = p.blu_1 })
	hl("@tag.attribute.tsx", { fg = p.blu_3 })
	hl("@function.method.call.tsx", { fg = p.orn_3 })
	hl("@function.method.call.tsx", { fg = p.orn_3 })
  hl("@type.tsx", { fg = p.blu_2 })

	-- Help
	link("@label.help", "Tag")

	-- Markdown
	hl("@markup.heading.markdown",        t.markup.heading)
	hl("@markup.heading.1.markdown",      t.markup.heading_1)
	hl("@markup.heading.2.markdown",      t.markup.heading_2)
	hl("@markup.heading.3.markdown",      t.markup.heading_3)
	hl("@markup.heading.4.markdown",      t.markup.heading_4)
	hl("@markup.heading.5.markdown",      t.markup.heading_5)
	hl("@markup.heading.6.markdown",      t.markup.heading_6)
	hl("@markup.heading.marker.markdown", t.markup.heading)
	hl("@markup.raw.markdown",       { fg = p.blu_3 })
	hl("@markup.raw.block.markdown", { fg = p.blu_3 })

end
-- stylua: ignore end

return languages
