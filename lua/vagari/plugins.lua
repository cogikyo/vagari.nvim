-- ============================================================================
-- Vagari Plugin Highlights
-- ============================================================================

local t = require("vagari.thalamus")
local h = require("vagari.helpers")
local hl = h.hl
local link = h.link

local plugins = {}

function plugins.setup()
	-- ========================================================================
	-- GitSigns
	-- ========================================================================

	hl("GitSignsAdd", t.state.add)
	hl("GitSignsAddLn", t.state.add_ln)
	hl("GitSignsAddNr", t.state.add)
	hl("GitSignsChange", t.state.dirty)
	hl("GitSignsChangeLn", t.state.dirty_ln)
	hl("GitSignsChangeNr", t.state.dirty)
	hl("GitSignsDelete", t.state.delete)
	hl("GitSignsDeleteLn", t.state.delete_ln)
	hl("GitSignsDeleteNr", t.state.delete)
	hl("GitSignsUntracked", t.state.new)

	-- ========================================================================
	-- NvimTree
	-- ========================================================================

	-- Window
	hl("NvimTreeNormal", t.tree.file)
	hl("NvimTreeNormalNC", t.tree.file)
	hl("NvimTreeNormalFloat", t.tree.file)
	hl("NvimTreeNormalFloatNC", t.tree.file)
	hl("NvimTreeNormalFloatBorder", t.idle.passive)
	hl("NvimTreeLineNr", t.passive.comment)
	hl("NvimTreeWinSeparator", t.passive.invis)
	hl("NvimTreePopup", t.idle.float)
	hl("NvimTreeSignColumn", t.passive.comment)
	hl("NvimTreeCursorColumn", t.passive.bg)
	hl("NvimTreeCursorLine", t.idle.bg)
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
	hl("NvimTreeOpenedHL", t.idle.passive)

	-- ========================================================================
	-- Telescope
	-- ========================================================================

	hl("TelescopeNormal", t.idle.float)
	hl("TelescopeBorder", t.idle.float)
	hl("TelescopeTitle", t.idle.bold)
	hl("TelescopePromptNormal", t.active.input)
	hl("TelescopePromptBorder", t.active.input)
	hl("TelescopePromptTitle", t.active.input)
	hl("TelescopeMatching", t.active.search)
	hl("TelescopePromptPrefix", t.active.active)
	hl("TelescopeSelection", t.active.select)
	hl("TelescopeSelectionCaret", t.active.select)

	-- ========================================================================
	-- Notify
	-- ========================================================================

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

	-- ========================================================================
	-- Noice
	-- ========================================================================

	hl("NoiceCmdline", t.passive.fg)
	hl("NoiceCmdlineIcon", t.msg.info.info)
	hl("NoiceCmdlineIconSearch", t.msg.warn.warn)
	hl("NoiceCmdlinePopup", t.idle.float)
	hl("NoiceCmdlinePopupBorder", t.msg.info.info)
	hl("NoiceCmdlinePopupBorderSearch", t.msg.warn.warn)
	hl("NoiceCmdlinePopupTitle", t.msg.info.info)
	hl("NoiceCmdlinePrompt", t.txt.title)
	hl("NoiceConfirm", t.idle.float)
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
	hl("NoiceLspProgressSpinner", t.constants.constant)
	hl("NoiceLspProgressTitle", t.passive.fg)
	hl("NoiceMini", t.passive.fg)
	hl("NoicePopup", t.idle.float)
	hl("NoicePopupBorder", t.idle.passive)
	hl("NoicePopupmenu", t.idle.float)
	hl("NoicePopupmenuBorder", t.idle.passive)
	link("NoicePopupmenuMatch", "Special")
	hl("NoicePopupmenuSelected", t.active.select)
	hl("NoiceScrollbar", t.idle.bg)
	hl("NoiceScrollbarThumb", t.idle.solid)
	hl("NoiceSplit", t.idle.float)
	hl("NoiceSplitBorder", t.idle.passive)
	hl("NoiceVirtualText", t.msg.info.virtual)

	-- ========================================================================
	-- Treesitter Context
	-- ========================================================================

	hl("TreesitterContext", t.idle.float)
	hl("TreesitterContextLineNumber", t.idle.float)

	-- ========================================================================
	-- Neominimap
	-- ========================================================================

	hl("NeominimapBorder", t.idle.passive)
	hl("NeominimapCursorLine", t.active.visual)
	hl("NeominimapCursorLineNr", t.active.select)
	hl("NeominimapCursorLineSign", t.active.visual)
	hl("NeominimapCursorLineFold", t.active.visual)

	-- Git
	hl("NeominimapGitAddSign", t.state.add)
	hl("NeominimapGitAddLine", t.state.add_ln)
	hl("NeominimapGitChangeSign", t.state.dirty)
	hl("NeominimapGitChangeLine", t.state.dirty_ln)
	hl("NeominimapGitDeleteSign", t.state.delete)
	hl("NeominimapGitDeleteLine", t.state.delete_ln)

	-- Diagnostics
	hl("NeominimapErrorLine", t.msg.error.virtual)
	hl("NeominimapWarnLine", t.msg.warn.virtual)
	hl("NeominimapInfoLine", t.msg.info.virtual)
	hl("NeominimapHintLine", t.msg.hint.virtual)

	-- Search
	hl("NeominimapSearchLine", t.active.search)
end

return plugins
