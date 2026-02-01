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
	if not t or not t.txt or not t.txt.txt then
		vim.notify("vagari: thalamus failed to load", vim.log.levels.ERROR)
		return
	end
	-- ========================================================================
	-- BASE: Vim syntax + UI groups (actual colors from thalamus)
	-- ========================================================================

	-- Editor UI
	hl("Normal", t.txt.txt)
	hl("NormalNC", t.passive.passive)
	hl("NormalFloat", t.idle.passive_br)
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
	hl("VirtColumn", t.passive.bfg)
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
	hl("ErrorMsg", t.msg.error.error)
	hl("WarningMsg", t.msg.warn.warn)
	hl("ModeMsg", t.idle.passive_br)
	hl("MsgArea", t.passive.fg)
	hl("MoreMsg", t.idle.idle)
	hl("MsgSeparator", t.idle.idle)
	hl("Question", t.idle.idle)

	-- Misc UI
	hl("Directory", t.misc.h1)
	hl("Title", t.misc.h1)
	hl("Conceal", t.idle.idle)
	hl("NonText", t.passive.fg)
	hl("SpecialKey", t.txt.inactive)
	hl("QuickFixLine", t.idle.passive_br)

	-- ========================================================================
	-- SYNTAX: Standard Vim groups (treesitter auto-links to these)
	-- ========================================================================

	-- Comments
	hl("Comment", t.passive.comment)

	-- Strings
	hl("String", t.strings.str)
	hl("Character", t.strings.char)

	-- Primitives
	hl("Number", t.primitives.num)
	hl("Boolean", t.primitives.bool)
	hl("Float", t.primitives.float)

	-- Constants
	hl("Constant", t.consts.const)

	-- Variables
	hl("Identifier", t.types.var)
	hl("Tag", t.types.tag)

	-- Functions
	hl("Function", t.functions.func)

	-- Keywords
	hl("Statement", t.keywords.keyword)
	hl("Conditional", t.keywords.logic)
	hl("Repeat", t.keywords.logic)
	hl("Label", t.keywords.label)
	hl("Keyword", t.keywords.keyword)
	hl("Exception", t.keywords.label)

	-- Operators
	hl("Operator", t.delimiters.operator)

	-- Preprocessor / External
	hl("PreProc", t.keywords.external)
	hl("Include", t.keywords.external)
	hl("Define", t.keywords.externaldef)
	hl("PreCondit", t.keywords.external)
	hl("Macro", t.functions.macro)

	-- Types
	hl("Type", t.types.type)
	hl("StorageClass", t.types.store)
	hl("Structure", t.types.struct)
	hl("Typedef", t.types.def)

	-- Delimiters & Special
	hl("Special", t.misc.special)
	hl("SpecialChar", t.misc.specialchar)
	hl("Delimiter", t.delimiters.delim)

	-- Apply all LSP highlights from thalamus
	for group, def in pairs(t.lsp) do
		hl(group, def)
	end
	hl("SpecialComment", t.msg.hint.special)
	hl("Debug", t.msg.hint.special)
	hl("Ignore", t.passive.fg)
	hl("Error", t.msg.error.error)
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

	hl("TypeBuiltin", t.types.builtin) -- int, bool, string
	hl("TypeDefinition", t.types.def) -- typedef, type alias
	hl("FunctionBuiltin", t.functions.builtin) -- print, len, make
	hl("FunctionMacro", t.functions.macro) -- macros, decorators
	hl("FunctionNamespace", t.functions.namespace) -- modules, packages
	hl("VariableBuiltin", t.types.varBuiltin) -- self, this, cls
	hl("VariableParameter", t.types.varParam) -- function params
	hl("VariableAttribute", t.types.attr) -- attributes
	hl("ConstantBuiltin", t.consts.builtin) -- nil, true, false
	hl("ConstantExternal", t.consts.external) -- preprocessor constants
	hl("KeywordFlow", t.keywords.flow) -- return, break
	hl("KeywordLogic", t.keywords.logic) -- if, for, while
	hl("KeywordDef", t.keywords.def) -- func, def, class
	hl("KeywordExternal", t.keywords.external) -- import, include
	hl("KeywordException", t.keywords.exception) -- throw, catch
	hl("StringDoc", t.strings.doc) -- docstrings
	hl("StringRegex", t.strings.regex) -- regex
	hl("StringSpecial", t.strings.special) -- special strings
	hl("DelimiterBracket", t.delimiters.bracket) -- (), {}, []
	hl("Link", t.misc.link) -- URLs

	-- ========================================================================
	-- TREESITTER: Explicit overrides only (auto-linking handles most)
	-- Groups like @comment auto-link to Comment, so we only define
	-- groups that need custom base groups or specific overrides
	-- ========================================================================

	-- Core treesitter groups
	link("@variable", "Identifier")
	hl("@variable.member", t.types.member)
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
	hl("@comment.documentation", t.strings.doc)
	link("@comment.error", "ErrorMsg")
	link("@comment.warning", "WarningMsg")
	hl("@comment.todo", t.msg.hint.special)
	hl("@comment.note", t.msg.info.info)

	-- Punctuation
	hl("@punctuation.delimiter", t.delimiters.delim)
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
	hl("@markup.list.checked", t.msg.success.success)
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
	-- DIAGNOSTICS
	-- ========================================================================

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
	-- Window
	hl("NvimTreeNormal", t.tree.file)
	hl("NvimTreeNormalFloat", t.tree.file)
	hl("NvimTreeNormalFloatBorder", t.idle.passive)
	hl("NvimTreeNormalNC", t.tree.file)
	hl("NvimTreeEndOfBuffer", t.idle.invis_br)
	hl("NvimTreeLineNr", t.passive.comment)
	hl("NvimTreeWinSeparator", t.idle.passive)
	hl("NvimTreePopup", t.idle.passive_br)
	hl("NvimTreeSignColumn", t.passive.comment)
	hl("NvimTreeCursorColumn", t.passive.bg)
	hl("NvimTreeCursorLine", t.passive.bg)
	hl("NvimTreeCursorLineNr", t.idle.passive)
	hl("NvimTreeStatusLine", t.passive.passive)
	hl("NvimTreeStatusLineNC", t.passive.passive)

	-- Folders
	hl("NvimTreeRootFolder", t.tree.dir)
	hl("NvimTreeFolderName", t.tree.dir)
	hl("NvimTreeEmptyFolderName", t.tree.dir)
	hl("NvimTreeOpenedFolderName", t.tree.dir)
	hl("NvimTreeSymlinkFolderName", t.tree.symlink)
	hl("NvimTreeFolderIcon", t.idle.idle)
	hl("NvimTreeOpenedFolderIcon", t.idle.idle)
	hl("NvimTreeClosedFolderIcon", t.idle.idle)
	hl("NvimTreeFolderArrowClosed", t.passive.comment)
	hl("NvimTreeFolderArrowOpen", t.passive.comment)
	hl("NvimTreeIndentMarker", t.passive.comment)

	-- Files
	hl("NvimTreeFileIcon", t.idle.idle)
	hl("NvimTreeExecFile", t.tree.exec)
	hl("NvimTreeSpecialFile", t.tree.file)
	hl("NvimTreeImageFile", t.tree.file)
	hl("NvimTreeSymlink", t.tree.symlink)
	hl("NvimTreeSymlinkIcon", t.tree.symlink)

	-- Git
	hl("NvimTreeGitDirty", t.state.modified)
	hl("NvimTreeGitNew", t.state.new)
	hl("NvimTreeGitDeleted", t.state.delete)
	hl("NvimTreeGitStaged", t.state.new)
	hl("NvimTreeGitMerge", t.state.modified)
	hl("NvimTreeGitRenamed", t.state.modified)
	hl("NvimTreeGitIgnored", t.passive.comment)
	hl("NvimTreeGitDirtyIcon", t.state.modified)
	hl("NvimTreeGitNewIcon", t.state.new)
	hl("NvimTreeGitDeletedIcon", t.state.delete)
	hl("NvimTreeGitStagedIcon", t.state.commit)
	hl("NvimTreeGitMergeIcon", t.state.modified)
	hl("NvimTreeGitRenamedIcon", t.state.rename)
	hl("NvimTreeGitIgnoredIcon", t.passive.comment)
	hl("NvimTreeGitFileDeletedHL", t.state.delete)
	hl("NvimTreeGitFileDirtyHL", t.state.modified)
	hl("NvimTreeGitFileIgnoredHL", t.passive.comment)
	hl("NvimTreeGitFileMergeHL", t.state.modified)
	hl("NvimTreeGitFileNewHL", t.state.new)
	hl("NvimTreeGitFileRenamedHL", t.state.modified)
	hl("NvimTreeGitFileStagedHL", t.state.commit)
	hl("NvimTreeGitFolderDeletedHL", t.state.delete)
	hl("NvimTreeGitFolderDirtyHL", t.state.modified)
	hl("NvimTreeGitFolderIgnoredHL", t.passive.comment)
	hl("NvimTreeGitFolderMergeHL", t.state.modified)
	hl("NvimTreeGitFolderNewHL", t.state.new)
	hl("NvimTreeGitFolderRenamedHL", t.state.rename)
	hl("NvimTreeGitFolderStagedHL", t.state.commit)

	-- Diagnostics
	hl("NvimTreeDiagnosticErrorIcon", t.msg.error.error)
	hl("NvimTreeDiagnosticWarnIcon", t.msg.warn.warn)
	hl("NvimTreeDiagnosticInfoIcon", t.msg.info.info)
	hl("NvimTreeDiagnosticHintIcon", t.msg.hint.hint)
	hl("NvimTreeDiagnosticErrorFileHL", t.msg.error.error)
	hl("NvimTreeDiagnosticWarnFileHL", t.msg.warn.warn)
	hl("NvimTreeDiagnosticInfoFileHL", t.msg.info.info)
	hl("NvimTreeDiagnosticHintFileHL", t.msg.hint.hint)
	hl("NvimTreeDiagnosticErrorFolderHL", t.msg.error.error)
	hl("NvimTreeDiagnosticWarnFolderHL", t.msg.warn.warn)
	hl("NvimTreeDiagnosticInfoFolderHL", t.msg.info.info)
	hl("NvimTreeDiagnosticHintFolderHL", t.msg.hint.hint)

	-- Misc
	hl("NvimTreeWindowPicker", t.active.select)
	hl("NvimTreeLiveFilterPrefix", t.active.active)
	hl("NvimTreeLiveFilterValue", t.txt.txt)
	hl("NvimTreeCutHL", t.state.delete)
	hl("NvimTreeCopiedHL", t.state.new)
	hl("NvimTreeBookmarkIcon", t.msg.hint.hint)
	hl("NvimTreeBookmarkHL", t.msg.hint.hint)
	hl("NvimTreeModifiedIcon", t.state.modified)
	hl("NvimTreeModifiedFileHL", t.state.modified)
	hl("NvimTreeModifiedFolderHL", t.state.modified)
	hl("NvimTreeHiddenIcon", t.passive.comment)
	hl("NvimTreeHiddenFileHL", t.passive.comment)
	hl("NvimTreeHiddenFolderHL", t.passive.comment)
	hl("NvimTreeHiddenDisplay", t.passive.comment)
	hl("NvimTreeOpenedHL", t.tree.file)

	-- Telescope
	hl("TelescopeNormal", t.idle.passive_br)
	hl("TelescopeBorder", t.idle.passive_br)
	hl("TelescopeTitle", t.idle.bold)
	hl("TelescopePromptNormal", t.active.input)
	hl("TelescopePromptBorder", t.active.input)
	hl("TelescopePromptTitle", t.active.input)
	hl("TelescopeMatching", t.active.search)
	hl("TelescopePromptPrefix", t.active.active)
	hl("TelescopeSelection", t.active.select)
	hl("TelescopeSelectionCaret", t.active.select)

	-- Notify
	hl("NotifyERRORBorder", t.msg.error.virtual)
	hl("NotifyERRORIcon", t.msg.error.error)
	hl("NotifyERRORTitle", t.msg.error.error)
	hl("NotifyWARNBorder", t.msg.warn.virtual)
	hl("NotifyWARNIcon", t.msg.warn.warn)
	hl("NotifyWARNTitle", t.msg.warn.warn)
	hl("NotifyINFOBorder", t.msg.info.virtual)
	hl("NotifyINFOIcon", t.msg.info.info)
	hl("NotifyINFOTitle", t.msg.info.info)
	hl("NotifyDEBUGBorder", t.passive.fg)
	hl("NotifyDEBUGIcon", t.passive.fg)
	hl("NotifyDEBUGTitle", t.passive.fg)
	hl("NotifyTRACEBorder", t.msg.hint.virtual)
	hl("NotifyTRACEIcon", t.msg.hint.hint)
	hl("NotifyTRACETitle", t.msg.hint.hint)

	-- Noice
	hl("NoiceCmdline", t.passive.fg)
	hl("NoiceCmdlineIcon", t.msg.info.info)
	hl("NoiceCmdlineIconSearch", t.msg.warn.warn)
	hl("NoiceCmdlinePopup", t.idle.passive_br)
	hl("NoiceCmdlinePopupBorder", t.msg.info.info)
	hl("NoiceCmdlinePopupBorderSearch", t.msg.warn.warn)
	hl("NoiceCmdlinePopupTitle", t.msg.info.info)
	hl("NoiceCmdlinePrompt", t.txt.title)
	hl("NoiceConfirm", t.idle.passive_br)
	hl("NoiceConfirmBorder", t.msg.info.info)
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
	hl("NoiceLspProgressSpinner", t.consts.const)
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
