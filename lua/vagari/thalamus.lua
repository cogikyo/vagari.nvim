local p = require("vagari.palette")

local function blend(hex, alpha)
	local bg = {
		tonumber(p.bg:sub(2, 3), 16),
		tonumber(p.bg:sub(4, 5), 16),
		tonumber(p.bg:sub(6, 7), 16),
	}
	local fg = {
		tonumber(hex:sub(2, 3), 16),
		tonumber(hex:sub(4, 5), 16),
		tonumber(hex:sub(6, 7), 16),
	}
	return string.format(
		"#%02x%02x%02x",
		math.floor(fg[1] * alpha + bg[1] * (1 - alpha) + 0.5),
		math.floor(fg[2] * alpha + bg[2] * (1 - alpha) + 0.5),
		math.floor(fg[3] * alpha + bg[3] * (1 - alpha) + 0.5)
	)
end

-- stylua: ignore start

local thalamus = {

-- ============================================================================
-- UI STATE (editor chrome)
-- ============================================================================

-- Text and typography
-- Color: fg/brt (blue-tinted white) — the default text ecosystem
txt = {
    txt       = { fg = p.fg, bg = p.bg },

    bright    = { fg = p.brt_1, fmt = "bold" },
    reverse   = { fg = p.bg, bg = p.brt_1 },
    file      = { fg = p.brt_0, bg = p.glc_0 },
    underline = { fg = p.brt_0, sp = p.brt_2, fmt = "underline" },

    title     = { fg = p.sky_2, fmt = "bold" },

    italic    = { fg = p.blu_4, fmt = "italic" },

    minor     = { fg = p.slt_5 },
    strike    = { fg = p.slt_4, fmt = "strikethrough" },

    inactive  = { fg = p.gry_1 },

    bold      = { fmt = "bold" },
},

-- Inactive/background elements
-- Color: drk/glc (dark blue) — recedes behind everything
passive = {
    invis      = { fg = p.bg },

    comment    = { fg = p.slt_2 },

    disown     = { fg = p.blu_0, bg = p.drk_1 },

    passive    = { fg = p.glc_4, bg = p.drk_0 },
    fg         = { fg = p.glc_4 },

    surface    = { fg = p.drk_1 },
    bg         = { bg = p.drk_0 },
},

-- Idle/resting UI state
-- Color: blu (mid blue) — present but not demanding attention
idle = {
    idle       = { fg = p.blu_2 },
    solid      = { bg = p.blu_2 },
    passive    = { fg = p.blu_2, bg = p.drk_0 },
    float      = { fg = p.blu_2, bg = p.glc_0 },
    context    = { fg = p.blu_2, bg = p.glc_1 },
    bold       = { fg = p.blu_2, fmt = "bold" },
    search     = { fg = p.blu_0 },
    ref        = { fg = p.blu_0, fmt = "bold" },

    bg         = { bg = p.glc_2 },
    invis_bg   = { fg = p.glc_0, bg = p.glc_0 },
},

-- Active/focused UI state
-- Color: orn (orange) — signal color, demands attention
active = {
    active = { fg = p.orn_4 },
    input  = { fg = p.orn_4, bg = p.glc_0 },
    select = { fg = p.orn_4, bg = p.glc_2, fmt = "bold" },
    search = { fg = p.orn_1, fmt = "bold" },

    visual = { bg = p.glc_2, fmt = "bold" },
},

-- Git diff and change state
-- Color: mixed signal colors — each state has its own identity
state = {
    commit      = { fg = p.orn_4 },

    new         = { fg = p.sun_2 },

    modified    = { fg = p.sky_2 },

    rename      = { fg = p.prp_2 },

    dirty       = { fg = p.glu_1 },

    add         = { fg = p.tyr_1 },

    delete      = { fg = p.his_1 },

    new_ln      = { bg = blend(p.pro_0, 0.20) },
    add_ln      = { bg = blend(p.tyr_0, 0.20) },
    dirty_ln    = { bg = blend(p.glu_0, 0.25) },
    delete_ln   = { bg = blend(p.his_0, 0.25) },
},

diff = {
    delta         = { fg = p.sky_2 },  -- @diff.delta: changed text
    plus          = { fg = p.tyr_1 },  -- @diff.plus: added text
    minus         = { fg = p.his_1 },  -- @diff.minus: deleted text
},

-- Diagnostics
-- Color: rby/sun/pnk/cyn — each severity has a distinct signal color
msg = {
    success = {
        success = { fg = p.emr_3 },
        inverse = { fg = p.emr_2, fmt = "reverse" },
    },
    error = {
        virtual = { fg = p.rby_4 },
        error   = { fg = p.rby_3 },
        inverse = { fg = p.rby_2, fmt = "reverse" },
        builtin = { fg = p.rby_1 },
        under   = { sp = p.rby_1, fmt = "undercurl" },
    },
    warn = {
        virtual = { fg = p.sun_4 },
        warn    = { fg = p.sun_3 },
        alt     = { fg = p.sun_2, fmt = "italic" },
        under   = { sp = p.sun_1, fmt = "undercurl" },
    },
    hint = {
        hint    = { fg = p.pnk_4 },
        under   = { sp = p.sky_1, fmt = "undercurl" },
        special = { fg = p.sky_1 },
        virtual = { fg = p.glc_2 },
    },
    info = {
        virtual = { fg = p.cyn_4 },
        info    = { fg = p.cyn_3 },
        under   = { sp = p.cyn_1, fmt = "undercurl" },
        custom  = { sp = p.cyn_1, fmt = "undercurl" },

        rare    = { sp = p.pnk_1, fmt = "undercurl" },
    },
},

-- SYNTAX (treesitter superset)

comments = {
    warning       = { fg = p.sun_3 },                  -- @comment.warning
    error         = { fg = p.rby_3 },                  -- @comment.error
    note          = { fg = p.cyn_3 },                  -- @comment.note
    todo          = { fg = p.sky_1 },                  -- @comment.todo
    documentation = { fg = p.glc_5, fmt = "italic" },  -- @comment.documentation
    comment       = { fg = p.slt_2 },                  -- @comment
},

strings = {
    special       = { fg = p.grn_4 },                  -- @string.special
    path          = { fg = p.grn_4 },                  -- @string.special.path
    str           = { fg = p.grn_3 },                  -- @string
    regexp        = { fg = p.grn_1 },                  -- @string.regexp

    symbol        = { fg = p.sky_1 },                  -- @string.special.symbol
    char_special  = { fg = p.sky_0 },                  -- @character.special

    url           = { fg = p.tyr_3 },                  -- @string.special.url
    escape        = { fg = p.tyr_2 },                  -- @string.escape
    char          = { fg = p.tyr_2 },                  -- @character

    documentation = { fg = p.glc_3 },                  -- @string.documentation
},

numbers = {
    float         = { fg = p.pnk_4, fmt = "italic" },  -- @number.float
    number        = { fg = p.pnk_2 },                  -- @number

    boolean       = { fg = p.cyn_2 },                  -- @boolean
},

identifiers = {
    variable       = { fg = p.fg },                     -- @variable

    parameter      = { fg = p.orn_4 },                  -- @variable.parameter
    param_builtin  = { fg = p.orn_3 },                  -- @variable.parameter.builtin
    builtin        = { fg = p.rby_3, fmt = "italic" },  -- @variable.builtin

    module         = { fg = p.brt_3 },                  -- @module

    member         = { fg = p.blu_3 },                  -- @variable.member
    property       = { fg = p.blu_3 },                  -- @property
    module_builtin = { fg = p.blu_2, fmt = "bold" },    -- @module.builti

    label          = { fg = p.prp_3 },                  -- @label
},

functions = {
    constructor   = { fg = p.brt_0, fmt = "bold" },    -- @constructor

    call          = { fg = p.orn_4 },                  -- @function.call
    method        = { fg = p.blu_3 },                  -- @function.method
    method_call   = { fg = p.blu_2 },                  -- @function.method.call
    def           = { fg = p.blu_2, fmt = "bold" },    -- @function
    macro         = { fg = p.blu_2, fmt = "italic" },  -- @function.macro
    builtin       = { fg = p.blu_1, fmt = "italic" },  -- @function.builtin

    decorator     = { fg = p.asn_2, fmt = "italic" },  -- @decorator
},

types = {
    enum          = { fg = p.orn_3, fmt = "italic" },  -- @type: enum definitions

    attr_builtin  = { fg = p.rby_3, fmt = "italic" },  -- @attribute.builtin: @property
    builtin       = { fg = p.rby_3, fmt = "italic" },  -- @type.builtin: int, bool, string
    interface     = { fg = p.rby_2, fmt = "italic" },  -- @type: interface definitions

    attr          = { fg = p.prp_3, fmt = "italic" },  -- @attribute: decorators, lifetimes

    param         = { fg = p.glu_3, fmt = "italic" },  -- @type: type parameters, generics
    qualifier     = { fg = p.glu_2, fmt = "italic" },  -- @type.qualifier: const, volatile
    store         = { fg = p.glu_3, fmt = "italic" },  -- @storageclass: static, extern

    definition    = { fg = p.brt_3, fmt = "bold" },    -- @type.definition: type name in declaration
    type          = { fg = p.brt_1, fmt = "italic" },  -- @type: general type references
    class         = { fg = p.brt_0, fmt = "italic" },  -- @type: class definitions
    struct        = { fg = p.brt_0, fmt = "italic" },  -- @type: struct definitions
    member        = { fg = p.brt_0 },                  -- @type: member types
},

constants = {
    constant      = { fg = p.sun_4 },                  -- @constant: named constants
    enum_member   = { fg = p.sun_3, fmt = "italic" },  -- @lsp.type.enumMember: enum values
    macro         = { fg = p.sun_2, fmt = "italic" },  -- @constant.macro: preprocessor constants

    builtin       = { fg = p.rby_2, fmt = "italic" },  -- @constant.builtin: nil, true, false
},

keywords = {
    debug         = { fg = p.sky_1 },                       -- @keyword.debug: debug statements

    exception     = { fg = p.rby_2, fmt = "italic" },       -- @keyword.exception: throw, catch, try

    modifier      = { fg = p.prp_3, fmt = "italic" },       -- @keyword.modifier: const, static, public
    keyword       = { fg = p.prp_2 },                       -- @keyword: general keywords
    coroutine     = { fg = p.prp_2, fmt = "bold" },         -- @keyword.coroutine: go, async, await
    func          = { fg = p.prp_2, fmt = "bold" },         -- @keyword.function: func, def, fn
    type          = { fg = p.prp_2, fmt = "bold" },         -- @keyword.type: struct, enum, class
    flow          = { fg = p.prp_2, fmt = "italic" },       -- @keyword.return: return, yield
    ternary       = { fg = p.prp_2, fmt = "italic,bold" },  -- @keyword.conditional.ternary: ?, :
    operator      = { fg = p.prp_1, fmt = "italic" },       -- @keyword.operator: and, or, not, in
    loop          = { fg = p.prp_1, fmt = "italic" },       -- @keyword.repeat: for, while, loop
    conditional   = { fg = p.prp_1, fmt = "italic" },       -- @keyword.conditional: if, else, match

    import        = { fg = p.asn_2, fmt = "italic" },       -- @keyword.import: import, from, require
    import_def    = { fg = p.asn_2, fmt = "italic,bold" },  -- @keyword.import: define-style imports
    directive     = { fg = p.asn_2, fmt = "italic" },       -- @keyword.directive: preprocessor, shebangs
    directive_def = { fg = p.asn_2, fmt = "italic,bold" },  -- @keyword.directive.define: #define
},

delimiters = {
    operator      = { fg = p.sky_4, fmt = "bold" },   -- @operator: + * = symbolic operators
    special       = { fg = p.sky_2 },                 -- @punctuation.special: interpolation braces

    bracket       = { fg = p.glu_3 },                 -- @punctuation.bracket: () {} []
    delimiter     = { fg = p.glu_2 },                 -- @punctuation.delimiter: ; . ,
},

tags = {
    attribute     = { fg = p.orn_4, fmt = "italic" },  -- @tag.attribute: tag attributes

    tag           = { fg = p.blu_2 },                  -- @tag: XML/HTML tag names
    builtin       = { fg = p.blu_1, fmt = "italic" },  -- @tag.builtin: HTML5 tags
    delimiter     = { fg = p.glu_2 },                  -- @tag.delimiter: < > /
},

markup = {
    underline      = { fg = p.brt_0, sp = p.brt_2, fmt = "underline" },  -- @markup.underline

    heading        = { fg = p.orn_4, bg = blend(p.orn_4, 0.10), fmt = "bold" },         -- @markup.heading
    heading_1      = { fg = p.orn_4, bg = blend(p.orn_4, 0.10), fmt = "bold,italic" },  -- @markup.heading.1
    heading_2      = { fg = p.orn_4, bg = blend(p.orn_4, 0.10) },                       -- @markup.heading.2
    heading_3      = { fg = p.orn_3, bg = blend(p.orn_3, 0.10), fmt = "bold" },         -- @markup.heading.3
    heading_4      = { fg = p.orn_3, bg = blend(p.orn_3, 0.10) },                       -- @markup.heading.4
    heading_5      = { fg = p.orn_3, bg = blend(p.orn_3, 0.10), fmt = "italic" },       -- @markup.heading.5
    heading_6      = { fg = p.orn_2, bg = blend(p.orn_2, 0.10) },                       -- @markup.heading.6
    math           = { fg = p.sky_1 },                                   -- @markup.math: $math$
    link_label     = { fg = p.brt_3, fmt = "bold" },                     -- @markup.link.label

    italic         = { fg = p.blu_4, fmt = "italic" },                   -- @markup.italic: *italic*

    link_url       = { fg = p.tyr_3 },                                   -- @markup.link.url

    raw            = { fg = p.grn_4 },                                   -- @markup.raw: `inline code`
    raw_block      = { fg = p.blu_3 },                                   -- @markup.raw.block: ```fenced```

    list_checked   = { fg = p.emr_3 },                                   -- @markup.list.checked: [x]

    quote          = { fg = p.slt_5 },                                   -- @markup.quote: > blockquote
    strikethrough  = { fg = p.slt_4, fmt = "strikethrough" },            -- @markup.strikethrough: ~~struck~~
    link           = { fg = p.slt_2 },                                   -- @markup.link: references, footnotes
    list_unchecked = { fg = p.slt_2 },                                   -- @markup.list.unchecked: [ ]

    list           = { fg = p.glu_2 },                                   -- @markup.list: list markers

    strong         = { fmt = "bold" },                                   -- @markup.strong: **bold**
},

tree = {
    file    = { fg = p.fg,    bg = p.glc_0 },
    exec    = { fg = p.orn_3 },
    symlink = { fg = p.sky_2, fmt = "italic" },
    dir     = { fg = p.blu_3, fmt = "bold" },
},

misc = {
    deprecated  = { sp = p.sun_1, fmt = "strikethrough" },
    link        = { fg = p.tyr_3 },
    specialchar = { fg = p.sky_0 },
},

}

-- stylua: ignore end

return thalamus
