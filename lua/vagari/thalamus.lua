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

-- ============================================================================
-- COLOR LANGUAGE
--
-- Blue ecosystem (dominant, recedes):
--   glc (glacier)  → backgrounds, surfaces         (CR 1.05–2.68)
--   slt (slate)    → muted text, comments          (CR 1.32–3.97)
--   glu (glue)     → delimiters, brackets          (CR 2.00–6.00)
--   blu (blue)     → functions, methods, idle UI    (CR 3.24–7.29)
--   sky (sky)      → params, properties, operators  (CR 5.12–9.11)
--   fg/brt         → base text, types, members      (CR 8.00–11.21)
--
-- Accent (orange family):
--   orn (orange)   → constants, enums, active state (CR 4.66–8.56)
--   asn (arsenic)  → decorators, imports           (CR 2.00–6.00)
--
-- Supporting:
--   prp (purple)   → keywords, control flow        (CR 3.24–7.29)
--   grn (green)    → strings                       (CR 4.20–9.11)
--
-- Signal (10%, draws attention):
--   sun (sun)      → constants, warnings           (CR 7.29–10.72)
--   rby (ruby)     → errors, exceptions            (CR 4.20–7.29)
--   emr (emerald)  → success                       (CR 4.20–8.56)
--   cyn (cyan)     → info diagnostics              (CR 5.66–10.12)
--   pnk (pink)     → numbers, hints                (CR 4.20–7.29)
--
-- Git/state backgrounds:
--   his (history)  → delete                        (CR 2.00–6.00)
--   tyr (tyrian)   → add                           (CR 2.00–6.00)
--   pro (prospect) → new                           (CR 2.00–6.00)
-- ============================================================================

local thalamus = {

-- ============================================================================
-- UI STATE (editor chrome)
-- ============================================================================

-- Text and typography
-- Color: fg/brt (blue-tinted white) — the default text ecosystem
txt = {
    txt       = { fg = p.fg, bg = p.bg },
    bright    = { fg = p.brt_1, fmt = "bold" },
    file      = { fg = p.brt_0, bg = p.glc_0 },
    minor     = { fg = p.slt_5 },
    bold      = { fmt = "bold" },
    italic    = { fg = p.blu_4, fmt = "italic" },
    underline = { fg = p.brt_0, sp = p.brt_2, fmt = "underline" },
    strike    = { fg = p.slt_4, fmt = "strikethrough" },
    title     = { fg = p.sky_2, fmt = "bold" },
    reverse   = { fg = p.bg, bg = p.brt_1 },
    inactive  = { fg = p.gry_1 },
},

-- Inactive/background elements
-- Color: drk/glc (dark blue) — recedes behind everything
passive = {
    comment    = { fg = p.slt_2 },
    invis      = { fg = p.bg },
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
    bg         = { bg = p.glc_2 },
    passive    = { fg = p.blu_2, bg = p.drk_0 },
    float      = { fg = p.blu_2, bg = p.glc_0 },
    context    = { fg = p.blu_2, bg = p.glc_1 },
    invis_bg   = { fg = p.glc_0, bg = p.glc_0 },
    bold       = { fg = p.blu_2, fmt = "bold" },
    search     = { fg = p.blu_0 },
    ref        = { fg = p.blu_0, fmt = "bold" },
},

-- Active/focused UI state
-- Color: orn (orange) — signal color, demands attention
active = {
    active = { fg = p.orn_4 },
    input  = { fg = p.orn_4, bg = p.glc_0 },
    select = { fg = p.orn_4, bg = p.glc_2, fmt = "bold" },
    visual = { bg = p.glc_2, fmt = "bold" },
    search = { fg = p.orn_1, fmt = "bold" },
},

-- Git diff and change state
-- Color: mixed signal colors — each state has its own identity
state = {
    commit      = { fg = p.orn_4 },
    add         = { fg = p.tyr_1 },
    modified    = { fg = p.sky_2 },
    dirty       = { fg = p.glu_1 },
    delete      = { fg = p.his_1 },
    new         = { fg = p.sun_2 },
    rename      = { fg = p.prp_2 },
    new_ln      = { bg = blend(p.pro_0, 0.30) },
    add_ln      = { bg = blend(p.tyr_0, 0.30) },
    dirty_ln    = { bg = blend(p.glu_0, 0.30) },
    delete_ln   = { bg = blend(p.his_0, 0.30) },
},

-- Diagnostics
-- Color: rby/sun/pnk/cyn — each severity has a distinct signal color
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
        hint    = { fg = p.pnk_4 },
        under   = { sp = p.sky_1, fmt = "undercurl" },
        special = { fg = p.sky_1 },
        virtual = { fg = p.glc_2 },
    },
    info = {
        info    = { fg = p.cyn_3 },
        under   = { sp = p.cyn_1, fmt = "undercurl" },
        custom  = { sp = p.cyn_1, fmt = "undercurl" },
        rare    = { sp = p.pnk_1, fmt = "undercurl" },
        virtual = { fg = p.cyn_4 },
    },
},

-- SYNTAX (treesitter superset)

comments = {
    comment       = { fg = p.slt_2 },                  -- @comment
    documentation = { fg = p.slt_4, fmt = "italic" },  -- @comment.documentation
    error         = { fg = p.rby_3 },                  -- @comment.error
    warning       = { fg = p.sun_3 },                  -- @comment.warning
    todo          = { fg = p.sky_1 },                  -- @comment.todo
    note          = { fg = p.cyn_3 },                  -- @comment.note
},

strings = {
    str           = { fg = p.grn_3 },                  -- @string
    documentation = { fg = p.glc_3 },                  -- @string.documentation
    regexp        = { fg = p.grn_1 },                  -- @string.regexp
    escape        = { fg = p.tyr_2 },                  -- @string.escape
    special       = { fg = p.grn_4 },                  -- @string.special
    symbol        = { fg = p.sky_1 },                  -- @string.special.symbol
    path          = { fg = p.grn_4 },                  -- @string.special.path
    url           = { fg = p.tyr_3 },                  -- @string.special.url
    char          = { fg = p.tyr_2 },                  -- @character
    char_special  = { fg = p.sky_0 },                  -- @character.special
},

numbers = {
    number        = { fg = p.pnk_2 },                  -- @number
    float         = { fg = p.pnk_4 },                  -- @number.float
    boolean       = { fg = p.cyn_2 },                  -- @boolean
},

identifiers = {
    variable       = { fg = p.fg },                    -- @variable
    parameter      = { fg = p.orn_4 },                 -- @variable.parameter
    param_builtin  = { fg = p.orn_3 },                 -- @variable.parameter.builtin
    builtin        = { fg = p.orn_3 },                 -- @variable.builtin
    member         = { fg = p.blu_3 },                 -- @variable.member

    property       = { fg = p.orn_4 },                 -- @property
    module         = { fg = p.blu_4, fmt = "italic" }, -- @module
    module_builtin = { fg = p.blu_2, fmt = "bold" },   -- @module.builtin
    label          = { fg = p.prp_3 },                 -- @label
},

functions =                                               {
    constructor   = { fg = p.brt_0, fmt = "bold" },    -- @constructor
    call          = { fg = p.blu_3 },                  -- @function.call
    method        = { fg = p.blu_3 },                  -- @function.method
    method_call   = { fg = p.blu_2 },                  -- @function.method.call
    def           = { fg = p.blu_2, fmt = "bold" },    -- @function
    macro         = { fg = p.blu_2, fmt = "italic" },  -- @function.macro
    builtin       = { fg = p.blu_0, fmt = "bold" },    -- @function.builtin
    decorator     = { fg = p.asn_2, fmt = "italic" },  -- @decorator
},

types = {
    attr          = { fg = p.asn_2, fmt = "italic" },  -- @attribute: decorators, lifetimes
    attr_builtin  = { fg = p.rby_3, fmt = "italic" },  -- @attribute.builtin: @property
    builtin       = { fg = p.glu_3, fmt = "italic" },  -- @type.builtin: int, bool, string
    class         = { fg = p.brt_0, fmt = "italic" },  -- @type: class definitions
    definition    = { fg = p.brt_1, fmt = "bold" },    -- @type.definition: type name in declaration
    enum          = { fg = p.orn_2, fmt = "italic" },  -- @type: enum definitions
    interface     = { fg = p.rby_2, fmt = "italic" },  -- @type: interface definitions
    member        = { fg = p.brt_0 },                  -- @type: member types
    param         = { fg = p.glu_3, fmt = "italic" },  -- @type: type parameters, generics
    qualifier     = { fg = p.glu_2, fmt = "italic" },  -- @type.qualifier: const, volatile
    store         = { fg = p.glu_3, fmt = "italic" },  -- @storageclass: static, extern
    struct        = { fg = p.brt_0, fmt = "italic" },  -- @type: struct definitions
    type          = { fg = p.brt_0, fmt = "italic" },  -- @type: general type references
},

constants = {
    constant      = { fg = p.orn_3 },                  -- @constant: named constants
    builtin       = { fg = p.rby_3, fmt = "italic" },  -- @constant.builtin: nil, true, false
    macro         = { fg = p.orn_1, fmt = "italic" },  -- @constant.macro: preprocessor constants
    enum_member   = { fg = p.orn_2, fmt = "italic" },  -- @lsp.type.enumMember: enum values
},

keywords = {
    keyword       = { fg = p.prp_2 },                       -- @keyword: general keywords
    coroutine     = { fg = p.prp_2, fmt = "bold" },         -- @keyword.coroutine: go, async, await
    func          = { fg = p.prp_2, fmt = "bold" },         -- @keyword.function: func, def, fn
    operator      = { fg = p.prp_1, fmt = "italic" },       -- @keyword.operator: and, or, not, in
    import        = { fg = p.asn_2, fmt = "italic" },       -- @keyword.import: import, from, require
    import_def    = { fg = p.asn_2, fmt = "italic,bold" },  -- @keyword.import: define-style imports
    type          = { fg = p.prp_2, fmt = "bold" },         -- @keyword.type: struct, enum, class
    modifier      = { fg = p.prp_3, fmt = "italic" },       -- @keyword.modifier: const, static, public
    loop          = { fg = p.prp_1, fmt = "italic" },       -- @keyword.repeat: for, while, loop
    flow          = { fg = p.prp_2, fmt = "italic" },       -- @keyword.return: return, yield
    debug         = { fg = p.sky_1 },                       -- @keyword.debug: debug statements
    conditional   = { fg = p.prp_1, fmt = "italic" },       -- @keyword.conditional: if, else, match

    exception     = { fg = p.rby_2, fmt = "italic" },       -- @keyword.exception: throw, catch, try
    ternary       = { fg = p.prp_2, fmt = "italic,bold" },  -- @keyword.conditional.ternary: ?, :
    directive     = { fg = p.asn_2, fmt = "italic" },       -- @keyword.directive: preprocessor, shebangs
    directive_def = { fg = p.asn_2, fmt = "italic,bold" },  -- @keyword.directive.define: #define
},

delimiters = {
    delimiter     = { fg = p.glu_2 },                 -- @punctuation.delimiter: ; . ,
    bracket       = { fg = p.glu_3 },                 -- @punctuation.bracket: () {} []
    special       = { fg = p.sky_2 },                 -- @punctuation.special: interpolation braces
    operator      = { fg = p.sky_4, fmt = "bold" },   -- @operator: + * = symbolic operators
},

tags = {
    tag           = { fg = p.sky_1 },                  -- @tag: XML/HTML tag names
    builtin       = { fg = p.sky_1 },                  -- @tag.builtin: HTML5 tags
    attribute     = { fg = p.sky_3, fmt = "italic" },  -- @tag.attribute: tag attributes
    delimiter     = { fg = p.glu_2 },                  -- @tag.delimiter: < > /
},

markup = {
    strong         = { fmt = "bold" },                                   -- @markup.strong: **bold**
    italic         = { fg = p.blu_4, fmt = "italic" },                   -- @markup.italic: *italic*
    strikethrough  = { fg = p.slt_4, fmt = "strikethrough" },            -- @markup.strikethrough: ~~struck~~
    underline      = { fg = p.brt_0, sp = p.brt_2, fmt = "underline" },  -- @markup.underline
    heading        = { fg = p.sky_2, fmt = "bold" },                     -- @markup.heading
    heading_1      = { fg = p.sky_2, fmt = "bold" },                     -- @markup.heading.1
    heading_2      = { fg = p.sky_2, fmt = "bold" },                     -- @markup.heading.2
    heading_3      = { fg = p.sky_2, fmt = "bold" },                     -- @markup.heading.3
    heading_4      = { fg = p.sky_2, fmt = "bold" },                     -- @markup.heading.4
    heading_5      = { fg = p.sky_2, fmt = "bold" },                     -- @markup.heading.5
    heading_6      = { fg = p.sky_2, fmt = "bold" },                     -- @markup.heading.6
    quote          = { fg = p.slt_5 },                                   -- @markup.quote: > blockquote
    math           = { fg = p.sky_1 },                                   -- @markup.math: $math$
    link           = { fg = p.slt_2 },                                   -- @markup.link: references, footnotes
    link_label     = { fg = p.sky_1 },                                   -- @markup.link.label
    link_url       = { fg = p.tyr_3 },                                   -- @markup.link.url
    raw            = { fg = p.grn_3 },                                   -- @markup.raw: `inline code`
    raw_block      = { fg = p.grn_3 },                                   -- @markup.raw.block: ```fenced```
    list           = { fg = p.glu_2 },                                   -- @markup.list: list markers
    list_checked   = { fg = p.emr_3 },                                   -- @markup.list.checked: [x]
    list_unchecked = { fg = p.slt_2 },                                   -- @markup.list.unchecked: [ ]
},

diff = {
    plus          = { fg = p.tyr_1 },  -- @diff.plus: added text
    minus         = { fg = p.his_1 },  -- @diff.minus: deleted text
    delta         = { fg = p.sky_2 },  -- @diff.delta: changed text
},

tree = {
    file    = { fg = p.fg,    bg = p.glc_0 },
    dir     = { fg = p.blu_3, fmt = "bold" },
    symlink = { fg = p.sky_2, fmt = "italic" },
    exec    = { fg = p.orn_3 },
},

misc = {
    deprecated  = { sp = p.sun_1, fmt = "strikethrough" },
    link        = { fg = p.tyr_3 },
    specialchar = { fg = p.sky_0 },
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

    ["@lsp.type.enumMember"] = thalamus.constants.enum_member,
    ["@lsp.typemod.function.defaultLibrary"] = thalamus.functions.builtin,
    ["@lsp.typemod.method.defaultLibrary"] = thalamus.functions.builtin,

    ["@lsp.mod.deprecated"] = thalamus.misc.deprecated,
}
-- stylua: ignore end

return thalamus
