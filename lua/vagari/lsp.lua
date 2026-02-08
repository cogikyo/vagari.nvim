-- ============================================================================
-- Vagari LSP & Diagnostics
-- ============================================================================

local t = require("vagari.thalamus")
local h = require("vagari.helpers")
local hl = h.hl

local lsp = {}

function lsp.setup()
	-- LSP semantic token overrides from thalamus
	for group, def in pairs(t.lsp) do
		hl(group, def)
	end

	-- Diagnostics
	hl("DiagnosticError", t.msg.error.error)
	hl("DiagnosticHint", t.msg.hint.hint)
	hl("DiagnosticInfo", t.msg.info.info)
	hl("DiagnosticWarn", t.msg.warn.warn)

	hl("DiagnosticVirtualTextError", t.msg.error.virtual)
	hl("DiagnosticVirtualTextWarn", t.msg.warn.virtual)
	hl("DiagnosticVirtualTextInfo", t.msg.info.virtual)
	hl("DiagnosticVirtualTextHint", t.msg.hint.virtual)

	hl("DiagnosticUnderlineError", t.msg.error.under)
	hl("DiagnosticUnderlineHint", t.msg.hint.under)
	hl("DiagnosticUnderlineInfo", t.msg.info.under)
	hl("DiagnosticUnderlineWarn", t.msg.warn.under)

	-- LSP references
	hl("LspReferenceText", t.txt.bold)
	hl("LspReferenceWrite", t.active.search)
	hl("LspReferenceRead", t.idle.ref)
end

return lsp
