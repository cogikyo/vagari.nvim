-- ============================================================================
-- Vagari Highlights
-- Strategy: Define base groups with colors, link treesitter/LSP to them
-- Edit thalamus.lua for colors, this file is infrastructure
-- ============================================================================

local t = require("vagari.thalamus")

local highlights = {}

-- Convert thalamus format to nvim_set_hl format
-- thalamus uses: { fg, bg, sp, fmt } where fmt = "bold,italic"
-- nvim_set_hl expects: { fg, bg, sp, bold = true, italic = true }
local function convert(def)
	if not def or type(def) ~= "table" then
		-- Return empty but valid highlight (inherits from Normal)
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

-- Modern API: nvim_set_hl replaces entire definition
local function hl(name, val)
	vim.api.nvim_set_hl(0, name, convert(val))
end

-- Helper for link-only definitions
local function link(name, target)
	vim.api.nvim_set_hl(0, name, { link = target })
end

function highlights.setup()
	-- Ensure thalamus loaded correctly
	if not t or not t.txt or not t.txt.norm then
		vim.notify("vagari: thalamus failed to load", vim.log.levels.ERROR)
		return
	end
	-- ========================================================================
	-- BASE: Vim syntax + UI groups (actual colors from thalamus)
	-- ========================================================================

	-- Editor UI
	hl("Normal", t.txt.norm)
	hl("NormalNC", t.passive.norm)
	hl("NormalFloat", t.idle.passive_br)
	hl("FloatBorder", t.idle.passive)
	hl("FloatTitle", t.idle.bold)
	hl("FloatFooter", t.passive.fg)
	hl("Cursor", t.txt.reverse)
	hl("lCursor", t.txt.reverse)
	hl("CursorIM", t.txt.reverse)
	hl("TermCursor", t.txt.reverse)
	hl("TermCursorNC", t.txt.reverse)
	hl("MatchParen", t.active.norm)
	hl("EndOfBuffer", t.passive.invis)
	hl("Whitespace", t.passive.comment)

	-- Line numbers & columns
	hl("LineNr", t.idle.bold)
	hl("LineNrAbove", t.passive.comment)
	hl("LineNrBelow", t.passive.comment)
	hl("CursorLineNr", t.idle.passive)
	hl("CursorLine", t.passive.bg)
	hl("CursorColumn", t.passive.bg)
	hl("ColorColumn", t.passive.bg)
	hl("VirtColumn", t.passive.bfg)
	hl("SignColumn", t.passive.comment)
	hl("CursorLineSign", t.passive.norm)
	hl("Folded", t.passive.norm)
	hl("FoldColumn", t.passive.norm)
	hl("CursorLineFold", t.idle.passive)

	-- Windows & tabs
	hl("WinSeparator", t.idle.passive)
	hl("WinBar", t.idle.passive)
	hl("WinBarNC", t.passive.norm)
	hl("StatusLine", t.passive.norm)
	hl("StatusLineNC", t.passive.norm)
	hl("TabLine", t.passive.norm)
	hl("TabLineFill", t.passive.bg)
	hl("TabLineSel", t.idle.passive_br)

	-- Popup menu
	hl("Pmenu", t.idle.passive_br)
	hl("PmenuSel", t.active.select)
	hl("PmenuSbar", t.idle.bg)
	hl("PmenuThumb", t.idle.solid)
	hl("WildMenu", t.active.select)

	-- Visual & search
	hl("Visual", t.active.visual)
	hl("VisualNOS", t.passive.disown)
	hl("Search", t.idle.search)
	hl("CurSearch", t.active.search)
	hl("IncSearch", t.active.search)
	hl("Substitute", t.active.search)

	-- Diff
	hl("DiffAdd", t.state.new)
	hl("DiffNew", t.state.new)
	hl("DiffChange", t.state.modified)
	hl("DiffText", t.state.modified)
	hl("DiffDelete", t.state.delete)

	-- Spelling
	hl("SpellBad", t.msg.error.under)
	hl("SpellCap", t.msg.hint.under)
	hl("SpellLocal", t.msg.info.custom)
	hl("SpellRare", t.msg.info.rare)

	-- Messages
	hl("ErrorMsg", t.msg.error.norm)
	hl("WarningMsg", t.msg.warn.norm)
	hl("ModeMsg", t.idle.passive_br)
	hl("MsgArea", t.passive.fg)
	hl("MoreMsg", t.idle.norm)
	hl("MsgSeparator", t.idle.norm)
	hl("Question", t.idle.norm)

	-- Misc UI
	hl("Directory", t.h1)
	hl("Title", t.h1)
	hl("Conceal", t.idle.norm)
	hl("NonText", t.passive.fg)
	hl("SpecialKey", t.txt.inactive)
	hl("QuickFixLine", t.idle.passive_br)

	-- ========================================================================
	-- SYNTAX: Standard Vim groups (treesitter auto-links to these)
	-- ========================================================================

	hl("Comment", t.passive.comment)
	hl("Constant", t.const.norm)
	hl("String", t.str.norm)
	hl("Character", t.str.char)
	hl("Number", t.num)
	hl("Boolean", t.bool)
	hl("Float", t.float)
	hl("Identifier", t.var.norm)
	hl("Function", t.func.norm)
	hl("Statement", t.keyword.norm)
	hl("Conditional", t.keyword.logic)
	hl("Repeat", t.keyword.logic)
	hl("Label", t.keyword.label)
	hl("Operator", t.operator)
	hl("Keyword", t.keyword.norm)
	hl("Exception", t.keyword.label)
	hl("PreProc", t.keyword.external)
	hl("Include", t.keyword.external)
	hl("Define", t.keyword.externaldef)
	hl("PreCondit", t.keyword.external)
	hl("Macro", t.func.macro)
	hl("Type", t.type.norm)
	hl("StorageClass", t.type.store)
	hl("Structure", t.type.struct)
	hl("Typedef", t.type.def)
	hl("Special", t.special)
	hl("SpecialChar", t.specialchar)
	hl("Tag", t.var.tag)
	hl("Delimiter", t.delim.norm)
	hl("SpecialComment", t.msg.hint.special)
	hl("Debug", t.msg.hint.special)
	hl("Ignore", t.passive.fg)
	hl("Error", t.msg.error.norm)
	hl("Todo", t.msg.hint.special)
	hl("Bold", t.txt.bold)
	hl("Italic", t.txt.italic)
	hl("Underlined", t.txt.underline)

	-- Health
	hl("healthError", t.msg.error.inverse)
	hl("healthSuccess", t.msg.success.inverse)
	hl("healthWarning", t.msg.warn.alt)

	-- Markdown (syntax fallback)
	hl("markdownHeadingRule", t.passive.comment)

	-- ========================================================================
	-- CUSTOM BASE: Groups for concepts Vim doesn't have
	-- Treesitter and LSP link to these
	-- ========================================================================

	hl("TypeBuiltin", t.type.builtin) -- int, bool, string
	hl("TypeDefinition", t.type.def) -- typedef, type alias
	hl("FunctionBuiltin", t.func.builtin) -- print, len, make
	hl("FunctionMacro", t.func.macro) -- macros, decorators
	hl("FunctionNamespace", t.func.namespace) -- modules, packages
	hl("VariableBuiltin", t.var.builtin) -- self, this, cls
	hl("VariableParameter", t.var.param) -- function params
	hl("VariableAttribute", t.var.attr) -- attributes
	hl("ConstantBuiltin", t.const.builtin) -- nil, true, false
	hl("ConstantExternal", t.const.external) -- preprocessor constants
	hl("KeywordFlow", t.keyword.flow) -- return, break
	hl("KeywordLogic", t.keyword.logic) -- if, for, while
	hl("KeywordDef", t.keyword.def) -- func, def, class
	hl("KeywordExternal", t.keyword.external) -- import, include
	hl("KeywordException", t.keyword.exception) -- throw, catch
	hl("StringDoc", t.str.doc) -- docstrings
	hl("StringRegex", t.str.regex) -- regex
	hl("StringSpecial", t.str.special) -- special strings
	hl("DelimiterBracket", t.delim.bracket) -- (), {}, []
	hl("Link", t.link) -- URLs

	-- ========================================================================
	-- TREESITTER: Explicit overrides only (auto-linking handles most)
	-- Groups like @comment auto-link to Comment, so we only define
	-- groups that need custom base groups or specific overrides
	-- ========================================================================

	-- Core treesitter groups (explicit to ensure they're always set)
	-- These should auto-link, but being explicit prevents any race conditions
	link("@variable", "Identifier")
	link("@variable.member", "Identifier")
	link("@function", "Function")
	link("@function.call", "Function")
	link("@function.method", "Function")
	link("@function.method.call", "Function")
	link("@constructor", "TypeDefinition")
	link("@type", "Type")
	link("@keyword", "Keyword")
	link("@string", "String")
	link("@number", "Number")
	link("@boolean", "Boolean")
	link("@comment", "Comment")
	link("@operator", "Operator")
	link("@constant", "Constant")

	-- Comments (override for documentation)
	hl("@comment.documentation", t.str.doc)
	link("@comment.error", "ErrorMsg")
	link("@comment.warning", "WarningMsg")
	hl("@comment.todo", t.msg.hint.special)
	hl("@comment.note", t.msg.info.norm)

	-- Punctuation
	hl("@punctuation.delimiter", t.delim.norm)
	link("@punctuation.bracket", "DelimiterBracket")
	link("@punctuation.special", "Special")

	-- Strings (override for variants)
	link("@string.documentation", "StringDoc")
	link("@string.regexp", "StringRegex")
	link("@string.escape", "Character")
	link("@string.special", "StringSpecial")
	link("@string.special.symbol", "VariableBuiltin")
	link("@string.special.url", "Link")

	-- Functions
	link("@function.builtin", "FunctionBuiltin")
	link("@function.macro", "FunctionMacro")

	-- Keywords
	link("@keyword.coroutine", "KeywordDef")
	link("@keyword.function", "KeywordDef")
	link("@keyword.operator", "KeywordLogic")
	link("@keyword.import", "KeywordExternal")
	link("@keyword.type", "KeywordDef")
	link("@keyword.modifier", "StorageClass")
	link("@keyword.repeat", "KeywordLogic")
	link("@keyword.return", "KeywordFlow")
	link("@keyword.debug", "Debug")
	link("@keyword.exception", "KeywordException")
	link("@keyword.conditional", "KeywordLogic")
	link("@keyword.conditional.ternary", "KeywordFlow")
	link("@keyword.directive", "KeywordExternal")
	link("@keyword.directive.define", "Define")

	-- Types
	link("@type.builtin", "TypeBuiltin")
	link("@type.definition", "TypeDefinition")
	link("@type.qualifier", "Structure")

	-- Attributes
	link("@attribute", "KeywordExternal")
	link("@attribute.builtin", "ConstantBuiltin")

	-- Variables
	link("@variable.builtin", "VariableBuiltin")
	link("@variable.parameter", "VariableParameter")
	link("@variable.parameter.builtin", "VariableBuiltin")

	-- Constants
	link("@constant.builtin", "ConstantBuiltin")
	link("@constant.macro", "ConstantExternal")

	-- Modules
	link("@module", "FunctionNamespace")
	link("@module.builtin", "FunctionBuiltin")

	-- Markup
	link("@markup.strong", "Bold")
	link("@markup.italic", "Italic")
	hl("@markup.strikethrough", t.txt.strike)
	link("@markup.underline", "Underlined")
	hl("@markup.heading", t.txt.title)
	hl("@markup.heading.1", t.txt.title)
	hl("@markup.heading.2", t.txt.title)
	hl("@markup.heading.3", t.txt.title)
	hl("@markup.heading.4", t.txt.title)
	hl("@markup.heading.5", t.txt.title)
	hl("@markup.heading.6", t.txt.title)
	hl("@markup.quote", t.txt.minor)
	hl("@markup.math", t.msg.hint.special)
	link("@markup.link", "Comment")
	link("@markup.link.label", "Tag")
	link("@markup.link.url", "Link")
	link("@markup.raw", "String")
	link("@markup.raw.block", "String")
	link("@markup.list", "Delimiter")
	hl("@markup.list.checked", t.msg.success.norm)
	link("@markup.list.unchecked", "Comment")

	-- Diff
	link("@diff.plus", "DiffAdd")
	link("@diff.minus", "DiffDelete")
	link("@diff.delta", "DiffChange")

	-- Tags (HTML/XML)
	link("@tag", "Tag")
	link("@tag.builtin", "Tag")
	link("@tag.attribute", "VariableAttribute")
	link("@tag.delimiter", "Delimiter")

	-- Language-specific overrides
	link("@type.toml", "Tag")
	link("@property.toml", "VariableParameter")
	link("@label.help", "Tag")

	-- ========================================================================
	-- LSP SEMANTIC TOKENS: Pure links (no direct colors)
	-- Links to same base groups as treesitter for consistency
	-- ========================================================================

	-- Basic types -> Vim syntax
	link("@lsp.type.class", "Type")
	link("@lsp.type.comment", "Comment")
	link("@lsp.type.decorator", "KeywordExternal")
	link("@lsp.type.enum", "Type")
	link("@lsp.type.enumMember", "ConstantBuiltin")
	link("@lsp.type.event", "Tag")
	link("@lsp.type.function", "Function")
	link("@lsp.type.interface", "Type")
	link("@lsp.type.keyword", "Keyword")
	link("@lsp.type.macro", "FunctionMacro")
	link("@lsp.type.method", "Function")
	link("@lsp.type.modifier", "StorageClass")
	link("@lsp.type.namespace", "FunctionNamespace")
	link("@lsp.type.number", "Number")
	link("@lsp.type.operator", "Operator")
	link("@lsp.type.parameter", "VariableParameter")
	link("@lsp.type.property", "Identifier")
	link("@lsp.type.regexp", "StringRegex")
	link("@lsp.type.string", "String")
	link("@lsp.type.struct", "Structure")
	link("@lsp.type.type", "Type")
	link("@lsp.type.typeParameter", "Type")
	link("@lsp.type.variable", "Identifier")

	-- Modifiers: only define the useful ones, leave others undefined
	-- Undefined @lsp.mod.* groups have no effect (type determines color)
	link("@lsp.mod.deprecated", "DiagnosticDeprecated")
	-- readonly/static are intentionally not defined to avoid conflicts

	-- Combined type+modifier -> custom base groups
	-- NOTE: For types, we link to Type (not TypeBuiltin) to match treesitter
	-- and avoid flash when LSP loads. Treesitter doesn't distinguish builtin types.
	link("@lsp.typemod.class.defaultLibrary", "Type")
	link("@lsp.typemod.enum.defaultLibrary", "Type")
	link("@lsp.typemod.enumMember.defaultLibrary", "ConstantBuiltin")
	link("@lsp.typemod.function.defaultLibrary", "FunctionBuiltin")
	link("@lsp.typemod.method.defaultLibrary", "FunctionBuiltin")
	link("@lsp.typemod.struct.defaultLibrary", "Type")
	link("@lsp.typemod.type.defaultLibrary", "Type")
	link("@lsp.typemod.type.string", "Type") -- gopls custom
	link("@lsp.typemod.typeAlias.defaultLibrary", "TypeBuiltin")
	link("@lsp.typemod.variable.defaultLibrary", "VariableBuiltin")
	link("@lsp.typemod.variable.readonly", "Constant")
	link("@lsp.typemod.operator.injected", "Operator")
	link("@lsp.typemod.string.injected", "String")
	link("@lsp.typemod.variable.injected", "Identifier")

	-- Deprecated highlight
	vim.api.nvim_set_hl(
		0,
		"DiagnosticDeprecated",
		{ strikethrough = true, sp = t.msg.warn.norm.fg }
	)

	-- ========================================================================
	-- DIAGNOSTICS
	-- ========================================================================

	hl("DiagnosticError", t.msg.error.norm)
	hl("DiagnosticHint", t.msg.hint.norm)
	hl("DiagnosticInfo", t.msg.info.norm)
	hl("DiagnosticWarn", t.msg.warn.norm)

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

	-- ========================================================================
	-- PLUGINS
	-- ========================================================================

	-- GitSigns
	hl("GitSignsAdd", t.state.new)
	hl("GitSignsAddLn", t.state.new)
	hl("GitSignsAddNr", t.state.new)
	hl("GitSignsChange", t.state.modified)
	hl("GitSignsChangeLn", t.state.modified)
	hl("GitSignsChangeNr", t.state.modified)
	hl("GitSignsDelete", t.state.delete)
	hl("GitSignsDeleteLn", t.state.delete)
	hl("GitSignsDeleteNr", t.state.delete)

	-- NvimTree
	hl("NvimTreeNormal", t.idle.passive_br)
	hl("NvimTreeEndOfBuffer", t.idle.invis_br)
	hl("NvimTreeRootFolder", t.txt.title)
	hl("NvimTreeGitDirty", t.state.modified)
	hl("NvimTreeGitNew", t.state.new)
	hl("NvimTreeGitDeleted", t.state.delete)
	link("NvimTreeSpecialFile", "Special")
	link("NvimTreeFolderName", "Tag")

	-- Telescope
	hl("TelescopeNormal", t.idle.passive_br)
	hl("TelescopeBorder", t.idle.passive_br)
	hl("TelescopeTitle", t.idle.bold)
	hl("TelescopePromptNormal", t.active.input)
	hl("TelescopePromptBorder", t.active.input)
	hl("TelescopePromptTitle", t.active.input)
	hl("TelescopeMatching", t.active.search)
	hl("TelescopePromptPrefix", t.active.norm)
	hl("TelescopeSelection", t.active.select)
	hl("TelescopeSelectionCaret", t.active.select)

	-- Notify
	hl("NotifyERRORBorder", t.msg.error.virtual)
	hl("NotifyERRORIcon", t.msg.error.norm)
	hl("NotifyERRORTitle", t.msg.error.norm)
	hl("NotifyWARNBorder", t.msg.warn.virtual)
	hl("NotifyWARNIcon", t.msg.warn.norm)
	hl("NotifyWARNTitle", t.msg.warn.norm)
	hl("NotifyINFOBorder", t.msg.info.virtual)
	hl("NotifyINFOIcon", t.msg.info.norm)
	hl("NotifyINFOTitle", t.msg.info.norm)
	hl("NotifyDEBUGBorder", t.passive.fg)
	hl("NotifyDEBUGIcon", t.passive.fg)
	hl("NotifyDEBUGTitle", t.passive.fg)
	hl("NotifyTRACEBorder", t.msg.hint.virtual)
	hl("NotifyTRACEIcon", t.msg.hint.norm)
	hl("NotifyTRACETitle", t.msg.hint.norm)

	-- Noice
	hl("NoiceCmdline", t.passive.fg)
	hl("NoiceCmdlineIcon", t.msg.info.norm)
	hl("NoiceCmdlineIconSearch", t.msg.warn.norm)
	hl("NoiceCmdlinePopup", t.idle.passive_br)
	hl("NoiceCmdlinePopupBorder", t.msg.info.norm)
	hl("NoiceCmdlinePopupBorderSearch", t.msg.warn.norm)
	hl("NoiceCmdlinePopupTitle", t.msg.info.norm)
	hl("NoiceCmdlinePrompt", t.txt.title)
	hl("NoiceConfirm", t.idle.passive_br)
	hl("NoiceConfirmBorder", t.msg.info.norm)
	hl("NoiceCursor", t.txt.reverse)
	hl("NoiceFormatConfirm", t.passive.bg)
	hl("NoiceFormatConfirmDefault", t.active.visual)
	hl("NoiceFormatLevelDebug", t.passive.fg)
	hl("NoiceFormatLevelError", t.msg.error.virtual)
	hl("NoiceFormatLevelInfo", t.msg.info.virtual)
	hl("NoiceFormatLevelWarn", t.msg.warn.virtual)
	hl("NoiceFormatProgressDone", t.idle.search)
	hl("NoiceFormatProgressTodo", t.passive.bg)
	hl("NoiceLspProgressClient", t.txt.title)
	hl("NoiceLspProgressSpinner", t.const.norm)
	hl("NoiceLspProgressTitle", t.passive.fg)
	hl("NoiceMini", t.passive.fg)
	hl("NoicePopup", t.idle.passive_br)
	hl("NoicePopupBorder", t.idle.passive)
	hl("NoicePopupmenu", t.idle.passive_br)
	hl("NoicePopupmenuBorder", t.idle.passive)
	link("NoicePopupmenuMatch", "Special")
	hl("NoicePopupmenuSelected", t.active.select)
	hl("NoiceScrollbar", t.idle.bg)
	hl("NoiceScrollbarThumb", t.idle.solid)
	hl("NoiceSplit", t.idle.passive_br)
	hl("NoiceSplitBorder", t.idle.passive)
	hl("NoiceVirtualText", t.msg.info.virtual)
end

return highlights
