local p = require("vagari.palette")

-- stylua: ignore start
local thalamus = {

	txt = {
		txt       = { fg = p.fg, bg = p.bg },
		minor     = { fg = p.slt_5 },
		bold      = { fmt = "bold" },
		italic    = { fg = p.blu_4, fmt = "italic" },
		underline = { fg = p.brt_0, sp = p.brt_2, fmt = "underline" },
		strike    = { fg = p.slt_4, fmt = "strikethrough" },
		title     = { fg = p.sky_2, fmt = "bold" },
		reverse   = { fg = p.bg, bg = p.brt_1 },
		inactive  = { fg = p.gry_1 },
	},

	passive = {
		comment    = { fg = p.slt_2 },
		invis      = { fg = p.bg },
		disown     = { fg = p.blu_0, bg = p.drk_1 },
		passive    = { fg = p.glc_4, bg = p.drk_0 },
		fg         = { fg = p.glc_4 },
		bfg        = { fg = p.drk_1 },
		bg         = { bg = p.drk_0 },
	},

	idle = {
		idle       = { fg = p.blu_2 },
		solid      = { bg = p.blu_2 },
		bg         = { bg = p.glc_2 },
		passive    = { fg = p.blu_2, bg = p.drk_0 },
		passive_br = { fg = p.blu_2, bg = p.glc_0 },
		invis_br   = { fg = p.glc_0, bg = p.glc_0 },
		bold       = { fg = p.blu_2, fmt = "bold" },
		search     = { fg = p.blu_0 },
		ref        = { fg = p.blu_0, fmt = "bold" },
	},

	active = {
		active = { fg = p.orn_4 },
		input  = { fg = p.orn_4, bg = p.glc_0 },
		select = { fg = p.orn_4, bg = p.glc_2, fmt = "bold" },
		visual = { bg = p.glc_2, fmt = "bold" },
		search = { fg = p.orn_1, fmt = "bold" },
	},

	state = {
		new      = { fg = p.tyr_2 },
		modified = { fg = p.glu_1 },
		delete   = { fg = p.his_1 },
	},

	msg = {
		success = {
			success = { fg = p.emr_3 },
			inverse = { fg = p.emr_2, fmt = "reverse" },
		},
		error = {
			builtin = { fg = p.rby_1 },
			error   = { fg = p.rby_3 },
			inverse = { fg = p.rby_2, fmt = "reverse" },
			under   = { sp = p.rby_1, fmt = "undercurl" },
			virtual = { fg = p.rby_4 },
		},
		warn = {
			warn    = { fg = p.sun_3 },
			alt     = { fg = p.sun_2, fmt = "italic" },
			under   = { sp = p.sun_1, fmt = "undercurl" },
			virtual = { fg = p.sun_4 },
		},
		hint = {
			hint    = { fg = p.sky_3 },
			under   = { sp = p.sky_1, fmt = "undercurl" },
			special = { fg = p.sky_1 },
			virtual = { fg = p.sky_4 },
		},
		info = {
			info    = { fg = p.cyn_3 },
			under   = { sp = p.cyn_1, fmt = "undercurl" },
			custom  = { sp = p.cyn_1, fmt = "undercurl" },
			rare    = { sp = p.pnk_1, fmt = "undercurl" },
			virtual = { fg = p.cyn_4 },
		},
	},

	strings = {
		str     = { fg = p.grn_3 },                       -- base string
		special = { fg = p.grn_4 },                       -- escape sequences
		regex   = { fg = p.grn_1 },                       -- regex patterns
		char    = { fg = p.tyr_2 },                       -- character literals
    doc     = { fg = p.glc_5 },
	},

	functions = {
		func      = { fg = p.orn_4 },                     -- base function
		method    = { fg = p.orn_4 },                     -- methods
		def       = { fg = p.orn_3, fmt = "bold" },       -- function definitions
		macro     = { fg = p.orn_3, fmt = "italic" },     -- macros
		namespace = { fg = p.orn_3, fmt = "italic" },                     -- modules/packages
		decorator = { fg = p.asn_2, fmt = "italic" },     -- decorators
		mehtod    = { fg = p.orn_2, fmt = "bold" },       -- print, len, make
	},

	consts = {
		const      = { fg = p.sun_3 },                    -- base constant
		readonly   = { fg = p.sun_2 },                    -- readonly vars
		builtin    = { fg = p.orn_1, fmt = "italic" },    -- nil, true, false
		enumMember = { fg = p.orn_2, fmt = "italic" },    -- enum values
		external   = { fg = p.asn_3, fmt = "italic" },    -- preprocessor
	},

	-- Types & Variables (blue/sky family)
	types = {
		struct     = { fg = p.blu_0, fmt = "italic" },    -- structs
		builtin    = { fg = p.prp_2 },    -- int, bool, string

		class      = { fg = p.blu_1, fmt = "italic" },    -- classes
		interface  = { fg = p.rby_2, fmt = "italic" },    -- interfaces
		enum       = { fg = p.orn_2, fmt = "italic" },    -- enums

		param      = { fg = p.blu_1, fmt = "italic" },    -- type parameters

		type       = { fg = p.blu_2, fmt = "italic" },    -- base type
		def        = { fg = p.blu_2, fmt = "bold" },      -- type definitions
		member     = { fg = p.brt_1 },                    -- struct members
		store      = { fg = p.blu_3, fmt = "italic" },    -- storage class

		varParam   = { fg = p.sky_3 },                    -- function params
		var        = { fg = p.blu_4 },                    -- base variable

		property   = { fg = p.sky_4 },                    -- object properties
		varBuiltin = { fg = p.sky_1 },                    -- self, this, cls
		attr       = { fg = p.sky_3, fmt = "italic" },    -- attributes

		tag        = { fg = p.sky_1 },                    -- HTML tags
		event      = { fg = p.sky_1 },                    -- events
	},

	-- Keywords
	keywords = {
		keyword   = { fg = p.prp_2 },     -- base keyword
		logic     = { fg = p.prp_1, fmt = "italic" },     -- if, for, while
		flow      = { fg = p.prp_2, fmt = "italic,bold" },       -- return, break
		def       = { fg = p.prp_2, fmt = "bold" },-- func, def, class
		label     = { fg = p.prp_3 },                     -- labels
		modifier  = { fg = p.prp_3, fmt = "italic" },     -- public, static
		exception = { fg = p.rby_2, fmt = "italic" },     -- throw, catch
		external  = { fg = p.asn_2, fmt = "italic" },     -- import, include
		externaldef = { fg = p.asn_2, fmt = "italic,bold" },
	},

	primitives = {
		num   = { fg = p.pnk_2 },
		float = { fg = p.pnk_4 },
		bool  = { fg = p.cyn_2 },
	},

	delimiters = {
		delim    = { fg = p.glu_2 },
		bracket  = { fg = p.glu_3 },
		operator = { fg = p.brt_2, fmt = "bold" },
	},

	misc = {
		link        = { fg = p.tyr_3 },
		specialchar = { fg = p.sky_0 },
		special     = { fg = p.sky_2 },
		h1          = { fg = p.sky_2 },
		deprecated  = { sp = p.sun_1, fmt = "strikethrough" },
	},
}

-- LSP semantic tokens: minimal overrides only
-- Neovim already links @lsp.type.X → @X → X by default
thalamus.lsp = {
	-- Clear to let treesitter win (shows @comment.todo, @comment.documentation)
	["@lsp.type.comment"] = {},

	-- Clear so treesitter's specific captures show (@variable.parameter, etc)
	["@lsp.type.variable"] = {},

	-- Clear so treesitter's @type.builtin wins over LSP
	["@lsp.type.type"] = {},

	["@lsp.type.enumMember"] = thalamus.consts.enumMember,
	["@lsp.typemod.function.defaultLibrary"] = thalamus.functions.mehtod,
	["@lsp.typemod.method.defaultLibrary"] = thalamus.functions.mehtod,

	["@lsp.mod.deprecated"] = thalamus.misc.deprecated,
}
-- stylua: ignore end

return thalamus
