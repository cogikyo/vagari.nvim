-- ============================================================================
-- Vagari Highlights
-- Mechanical wiring: thalamus → vim groups + treesitter captures
-- Edit thalamus.lua for colors, this file is infrastructure
-- ============================================================================

local t = require("vagari.thalamus")
local h = require("vagari.helpers")
local hl = h.hl

local highlights = {}

function highlights.setup()
	if not t or not t.txt or not t.txt.txt then
		vim.notify("vagari: thalamus failed to load", vim.log.levels.ERROR)
		return
	end

	-- ========================================================================
	-- EDITOR UI → thalamus.txt / passive / idle / active
	-- ========================================================================

	-- Core
	hl("Normal", t.txt.txt)
	hl("NormalNC", t.passive.bg)
	hl("NormalFloat", t.idle.float)
	hl("FloatBorder", t.idle.passive)
	hl("FloatTitle", t.idle.bold)
	hl("FloatFooter", t.passive.fg)
	hl("Cursor", t.txt.reverse)
	hl("lCursor", t.txt.reverse)
	hl("CursorIM", t.txt.reverse)
	hl("TermCursor", t.txt.reverse)
	hl("TermCursorNC", t.txt.reverse)
	hl("MatchParen", t.active.active)
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
	hl("VirtColumn", t.passive.surface)
	hl("SignColumn", t.passive.comment)
	hl("CursorLineSign", t.passive.passive)
	hl("Folded", t.passive.passive)
	hl("FoldColumn", t.passive.passive)
	hl("CursorLineFold", t.idle.passive)

	-- Windows & tabs
	hl("WinSeparator", t.idle.passive)
	hl("WinBar", t.idle.passive)
	hl("WinBarNC", t.passive.passive)
	hl("StatusLine", t.passive.passive)
	hl("StatusLineNC", t.passive.passive)
	hl("TabLine", t.passive.passive)
	hl("TabLineFill", t.passive.bg)
	hl("TabLineSel", t.idle.float)

	-- Popup menu
	hl("Pmenu", t.idle.float)
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
	hl("DiffAdd", t.state.add)
	hl("DiffNew", t.state.add)
	hl("DiffChange", t.state.modified)
	hl("DiffText", t.state.modified)
	hl("DiffDelete", t.state.delete)

	-- Spelling
	hl("SpellBad", t.msg.error.under)
	hl("SpellCap", t.msg.hint.under)
	hl("SpellLocal", t.msg.info.custom)
	hl("SpellRare", t.msg.info.rare)

	-- Messages
	hl("ErrorMsg", t.msg.error.error)
	hl("WarningMsg", t.msg.warn.warn)
	hl("ModeMsg", t.idle.float)
	hl("MsgArea", t.passive.fg)
	hl("MoreMsg", t.idle.idle)
	hl("MsgSeparator", t.idle.idle)
	hl("Question", t.idle.idle)

	-- Misc UI
	hl("Directory", t.txt.title)
	hl("Title", t.txt.title)
	hl("Conceal", t.idle.idle)
	hl("NonText", t.passive.fg)
	hl("SpecialKey", t.txt.inactive)
	hl("QuickFixLine", t.idle.float)

	-- Health
	hl("healthError", t.msg.error.inverse)
	hl("healthSuccess", t.msg.success.inverse)
	hl("healthWarning", t.msg.warn.alt)

	-- ========================================================================
	-- VIM SYNTAX (legacy fallback when treesitter not available)
	-- ========================================================================

	hl("Comment", t.comments.comment)
	hl("String", t.strings.str)
	hl("Character", t.strings.char)
	hl("Number", t.numbers.number)
	hl("Boolean", t.numbers.boolean)
	hl("Float", t.numbers.float)
	hl("Constant", t.constants.constant)
	hl("Identifier", t.identifiers.variable)
	hl("Tag", t.tags.tag)
	hl("Function", t.functions.call)
	hl("Statement", t.keywords.keyword)
	hl("Conditional", t.keywords.conditional)
	hl("Repeat", t.keywords.loop)
	hl("Label", t.identifiers.label)
	hl("Keyword", t.keywords.keyword)
	hl("Exception", t.keywords.exception)
	hl("Operator", t.delimiters.operator)
	hl("PreProc", t.keywords.directive)
	hl("Include", t.keywords.import)
	hl("Define", t.keywords.import_def)
	hl("PreCondit", t.keywords.directive)
	hl("Macro", t.functions.macro)
	hl("Type", t.types.type)
	hl("StorageClass", t.types.store)
	hl("Structure", t.types.struct)
	hl("Typedef", t.types.definition)
	hl("Special", t.delimiters.special)
	hl("SpecialChar", t.misc.specialchar)
	hl("Delimiter", t.delimiters.delimiter)
	hl("SpecialComment", t.msg.hint.special)
	hl("Debug", t.keywords.debug)
	hl("Ignore", t.passive.fg)
	hl("Error", t.msg.error.error)
	hl("Todo", t.msg.hint.special)
	hl("Bold", t.txt.bold)
	hl("Italic", t.txt.italic)
	hl("Underlined", t.txt.underline)

	-- Markdown (legacy syntax fallback)
	hl("markdownHeadingRule", t.passive.comment)

	-- ========================================================================
	-- TREESITTER — direct hl() from thalamus, no link() collapsing
	-- ========================================================================

	-- @comment.* → thalamus.comments
	hl("@comment", t.comments.comment)
	hl("@comment.documentation", t.comments.documentation)
	hl("@comment.documentation.go", t.comments.comment)
	hl("@comment.documentation.godoc", t.comments.documentation)
	hl("@comment.error", t.comments.error)
	hl("@comment.warning", t.comments.warning)
	hl("@comment.todo", t.comments.todo)
	hl("@comment.note", t.comments.note)

	-- @string.* → thalamus.strings
	hl("@string", t.strings.str)
	hl("@string.documentation", t.strings.documentation)
	hl("@string.regexp", t.strings.regexp)
	hl("@string.escape", t.strings.escape)
	hl("@string.special", t.strings.special)
	hl("@string.special.symbol", t.strings.symbol)
	hl("@string.special.path", t.strings.path)
	hl("@string.special.url", t.strings.url)
	hl("@character", t.strings.char)
	hl("@character.special", t.strings.char_special)

	-- @number.* / @boolean → thalamus.numbers
	hl("@number", t.numbers.number)
	hl("@number.float", t.numbers.float)
	hl("@boolean", t.numbers.boolean)

	-- @variable.* / @module.* / @label / @property → thalamus.identifiers
	hl("@variable", t.identifiers.variable)
	hl("@variable.builtin", t.identifiers.builtin)
	hl("@variable.parameter", t.identifiers.parameter)
	hl("@variable.parameter.builtin", t.identifiers.param_builtin)
	hl("@variable.member", t.identifiers.member)
	hl("@property", t.identifiers.property)
	hl("@module", t.identifiers.module)
	hl("@module.builtin", t.identifiers.module_builtin)
	hl("@label", t.identifiers.label)

	-- @function.* / @constructor → thalamus.functions
	hl("@function", t.functions.def)
	hl("@function.builtin", t.functions.builtin)
	hl("@function.call", t.functions.call)
	hl("@function.macro", t.functions.macro)
	hl("@function.method", t.functions.method)
	hl("@function.method.call", t.functions.method_call)
	hl("@constructor", t.functions.constructor)

	-- @type.* / @attribute.* → thalamus.types
	hl("@type", t.types.type)
	hl("@type.builtin", t.types.builtin)
	hl("@type.definition", t.types.definition)
	hl("@type.qualifier", t.types.qualifier)
	hl("@attribute", t.types.attr)
	hl("@attribute.builtin", t.types.attr_builtin)

	-- @constant.* → thalamus.constants
	hl("@constant", t.constants.constant)
	hl("@constant.builtin", t.constants.builtin)
	hl("@constant.macro", t.constants.macro)

	-- @keyword.* → thalamus.keywords
	hl("@keyword", t.keywords.keyword)
	hl("@keyword.coroutine", t.keywords.coroutine)
	hl("@keyword.function", t.keywords.func)
	hl("@keyword.operator", t.keywords.operator)
	hl("@keyword.import", t.keywords.import)
	hl("@keyword.type", t.keywords.type)
	hl("@keyword.modifier", t.keywords.modifier)
	hl("@keyword.repeat", t.keywords.loop)
	hl("@keyword.return", t.keywords.flow)
	hl("@keyword.debug", t.keywords.debug)
	hl("@keyword.exception", t.keywords.exception)
	hl("@keyword.conditional", t.keywords.conditional)
	hl("@keyword.conditional.ternary", t.keywords.ternary)
	hl("@keyword.directive", t.keywords.directive)
	hl("@keyword.directive.define", t.keywords.directive_def)

	-- @punctuation.* / @operator → thalamus.delimiters
	hl("@punctuation.delimiter", t.delimiters.delimiter)
	hl("@punctuation.bracket", t.delimiters.bracket)
	hl("@punctuation.special", t.delimiters.special)
	hl("@operator", t.delimiters.operator)

	-- @tag.* → thalamus.tags
	hl("@tag", t.tags.tag)
	hl("@tag.builtin", t.tags.builtin)
	hl("@tag.attribute", t.tags.attribute)
	hl("@tag.delimiter", t.tags.delimiter)

	-- @markup.* → thalamus.markup
	hl("@markup.strong", t.markup.strong)
	hl("@markup.italic", t.markup.italic)
	hl("@markup.strikethrough", t.markup.strikethrough)
	hl("@markup.underline", t.markup.underline)
	hl("@markup.heading", t.markup.heading)
	hl("@markup.heading.1", t.markup.heading_1)
	hl("@markup.heading.2", t.markup.heading_2)
	hl("@markup.heading.3", t.markup.heading_3)
	hl("@markup.heading.4", t.markup.heading_4)
	hl("@markup.heading.5", t.markup.heading_5)
	hl("@markup.heading.6", t.markup.heading_6)
	hl("@markup.quote", t.markup.quote)
	hl("@markup.math", t.markup.math)
	hl("@markup.link", t.markup.link)
	hl("@markup.link.label", t.markup.link_label)
	hl("@markup.link.url", t.markup.link_url)
	hl("@markup.raw", t.markup.raw)
	hl("@markup.raw.block", t.markup.raw_block)
	hl("@markup.list", t.markup.list)
	hl("@markup.list.checked", t.markup.list_checked)
	hl("@markup.list.unchecked", t.markup.list_unchecked)

	-- @diff.* → thalamus.diff
	hl("@diff.plus", t.diff.plus)
	hl("@diff.minus", t.diff.minus)
	hl("@diff.delta", t.diff.delta)
end

return highlights
