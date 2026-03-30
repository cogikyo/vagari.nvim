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
--   blu (blue)     → types, variables, idle UI     (CR 3.24–7.29)
--   sky (sky)      → params, properties, operators (CR 5.12–9.11)
--   fg/brt         → base text, members            (CR 8.00–11.21)
--
-- Accent (orange family):
--   orn (orange)   → functions, active state       (CR 4.66–8.56)
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

-- ============================================================================
-- SYNTAX (treesitter superset)
-- Every @capture gets its own key — intentional sharing is visible
-- ============================================================================

-- @comment                       base comment
-- @comment.documentation         documentation comments
-- @comment.error                 ERROR, FIXME, DEPRECATED markers
-- @comment.warning               WARNING, FIX, HACK markers
-- @comment.todo                  TODO, WIP markers
-- @comment.note                  NOTE, INFO, XXX markers
-- Color: slt (slate) — desaturated blue, recedes from code
-- Markers use signal colors to stand out from surrounding comments
comments = {
    comment       = { fg = p.slt_2 },
    documentation = { fg = p.glc_5 },
    error         = { fg = p.rby_3 },
    warning       = { fg = p.sun_3 },
    todo          = { fg = p.sky_1 },
    note          = { fg = p.cyn_3 },
},

-- @string                        string literals
-- @string.documentation          docstrings (Python, Lua)
-- @string.regexp                 regular expressions
-- @string.escape                 escape sequences (\n, \t)
-- @string.special                other special strings (dates, etc.)
-- @string.special.symbol         symbols or atoms (:ruby_symbol)
-- @string.special.path           filenames
-- @string.special.url            URIs, hyperlinks
-- @character                     character literals ('a')
-- @character.special             special characters (wildcards)
-- Color: grn (green) — universal convention, green = text data
-- escape/char use tyr (tyrian green) — distinct from string content
-- url uses tyr_3 — link color, navigable
strings = {
    str           = { fg = p.grn_3 },
    documentation = { fg = p.glc_5 },
    regexp        = { fg = p.grn_1 },
    escape        = { fg = p.tyr_2 },
    special       = { fg = p.grn_4 },
    symbol        = { fg = p.sky_1 },
    path          = { fg = p.grn_4 },
    url           = { fg = p.tyr_3 },
    char          = { fg = p.tyr_2 },
    char_special  = { fg = p.sky_0 },
},

-- @number                        numeric literals
-- @number.float                  floating-point numbers
-- @boolean                       boolean literals (true/false)
-- Color: pnk (pink) for numbers, cyn (cyan) for booleans
-- Both are rare in most code — small accent that doesn't dominate
numbers = {
    number        = { fg = p.pnk_2 },
    float         = { fg = p.pnk_4 },
    boolean       = { fg = p.cyn_2 },
},

-- @variable                      various variable names
-- @variable.builtin              self, this, cls
-- @variable.parameter            function parameters
-- @variable.parameter.builtin    special params (_, it)
-- @variable.member               object/struct fields
-- @property                      key in key/value pairs
-- @module                        modules or namespaces
-- @module.builtin                built-in modules
-- @label                         GOTO labels, heredoc labels
-- Color: fg/brt/sky (blue-tinted white ecosystem)
-- Most common tokens — should feel neutral, part of the text
-- module uses orn (orange) — imported namespaces feel like function-adjacent
-- label uses prp (purple) — control flow adjacent
identifiers = {
    variable      = { fg = p.blu_4 },
    builtin       = { fg = p.sky_1 },
    parameter     = { fg = p.sky_3 },
    param_builtin = { fg = p.sky_1 },
    member        = { fg = p.brt_1 },
    property      = { fg = p.sky_4 },
    module        = { fg = p.orn_3, fmt = "italic" },
    module_builtin = { fg = p.orn_2, fmt = "bold" },
    label         = { fg = p.prp_3 },
},

-- @function                      function definitions
-- @function.builtin              built-in functions (print, len, make)
-- @function.call                 function calls
-- @function.macro                preprocessor macros
-- @function.method               method definitions
-- @function.method.call          method calls
-- @constructor                   constructor calls and definitions
-- Color: orn (orange) — main accent color
-- Contrast: call (bright orn_4) → def (mid orn_3, bold) → builtin (darker orn_2, bold)
-- constructor uses blu (types family) — it creates types
-- decorator uses asn (accent purple) — metadata, not a function call
functions = {
    call          = { fg = p.orn_4 },
    method        = { fg = p.orn_4 },
    method_call   = { fg = p.orn_4 },
    def           = { fg = p.orn_3, fmt = "bold" },
    builtin       = { fg = p.orn_2, fmt = "bold" },
    macro         = { fg = p.orn_3, fmt = "italic" },
    constructor   = { fg = p.blu_2, fmt = "bold" },
    decorator     = { fg = p.asn_2, fmt = "italic" },
},

-- @type                          type or class definitions
-- @type.builtin                  built-in types (int, bool, string)
-- @type.definition               identifiers in type definitions
-- @type.qualifier                type qualifiers (const, volatile)
-- @attribute                     annotations (decorators, lifetimes)
-- @attribute.builtin             built-in annotations (@property)
-- Color: blu (blue family), italic distinguishes from identifiers
-- builtin uses prp (purple) — reads like a keyword in most languages
-- interface uses rby (ruby) — contracts are important, deserve signal
-- enum uses orn — accent, stands out from regular types
-- attr uses asn (accent purple) — metadata boundary
-- attr_builtin uses rby — built-in annotations are important to notice
types = {
    attr          = { fg = p.asn_2, fmt = "italic" },
    attr_builtin  = { fg = p.rby_3, fmt = "italic" },
    builtin       = { fg = p.prp_2, fmt = "italic" },
    class         = { fg = p.blu_1, fmt = "italic" },
    definition    = { fg = p.blu_2, fmt = "bold" },
    enum          = { fg = p.orn_2, fmt = "italic" },
    interface     = { fg = p.rby_2, fmt = "italic" },
    member        = { fg = p.brt_1 },
    param         = { fg = p.blu_1, fmt = "italic" },
    qualifier     = { fg = p.blu_0, fmt = "italic" },
    store         = { fg = p.blu_3, fmt = "italic" },
    struct        = { fg = p.blu_0, fmt = "italic" },
    type          = { fg = p.blu_2, fmt = "italic" },
},

-- @constant                      constant identifiers
-- @constant.builtin              nil, true, false
-- @constant.macro                preprocessor constants
-- Color: sun (warm yellow) — "fixed value" feeling
-- builtin uses rby (ruby) — nil/true/false are important to notice
-- macro uses asn — preprocessor boundary
-- enum_member uses orn — accent, matches enum type
constants = {
    constant      = { fg = p.sun_3 },
    builtin       = { fg = p.rby_3, fmt = "italic" },
    macro         = { fg = p.asn_3, fmt = "italic" },
    enum_member   = { fg = p.orn_2, fmt = "italic" },
},

-- @keyword                       general keywords
-- @keyword.coroutine             go, async, await
-- @keyword.function              func, def, fn
-- @keyword.operator              and, or, not, in
-- @keyword.import                import, from, include, require
-- @keyword.type                  struct, enum, class, interface
-- @keyword.modifier              const, static, public, private
-- @keyword.repeat                for, while, loop
-- @keyword.return                return, yield
-- @keyword.debug                 debug-related keywords
-- @keyword.exception             throw, catch, try, finally
-- @keyword.conditional           if, else, switch, match
-- @keyword.conditional.ternary   ?, : (ternary operator)
-- @keyword.directive             preprocessor directives, shebangs
-- @keyword.directive.define      #define
-- Color: prp (purple) — control flow and structure
-- Contrast: base (prp_2) → logic (prp_1, italic) → modifier (prp_3, italic)
-- import/directive uses asn (accent purple) — external boundary
-- exception uses rby (ruby) — error handling is signal-worthy
-- modifier uses blu_3 — behaves like type qualifier, blue family
-- debug uses sky_1 — hint-adjacent, informational
keywords = {
    keyword       = { fg = p.prp_2 },
    coroutine     = { fg = p.prp_2, fmt = "bold" },
    func          = { fg = p.prp_2, fmt = "bold" },
    operator      = { fg = p.prp_1, fmt = "italic" },
    import        = { fg = p.asn_2, fmt = "italic" },
    import_def    = { fg = p.asn_2, fmt = "italic,bold" },
    type          = { fg = p.prp_2, fmt = "bold" },
    modifier      = { fg = p.prp_3, fmt = "italic" },
    loop          = { fg = p.prp_1, fmt = "italic" },
    flow          = { fg = p.prp_2, fmt = "italic,bold" },
    debug         = { fg = p.sky_1 },
    exception     = { fg = p.rby_2, fmt = "italic" },
    conditional   = { fg = p.prp_1, fmt = "italic" },
    ternary       = { fg = p.prp_2, fmt = "italic,bold" },
    directive     = { fg = p.asn_2, fmt = "italic" },
    directive_def = { fg = p.asn_2, fmt = "italic,bold" },
},

-- @punctuation.delimiter         ; . ,
-- @punctuation.bracket           () {} []
-- @punctuation.special           {} in string interpolation
-- @operator                      + * = symbolic operators
-- Color: glu (desaturated blue) — structural, recedes
-- operator uses sky_3 — slightly brighter because operators matter semantically
delimiters = {
    delimiter     = { fg = p.glu_2 },
    bracket       = { fg = p.glu_3 },
    special       = { fg = p.sky_2 },
    operator      = { fg = p.sky_3, fmt = "bold" },
},

-- @tag                           XML-style tag names
-- @tag.builtin                   built-in tags (HTML5)
-- @tag.attribute                 tag attributes
-- @tag.delimiter                 < > / in tags
-- Color: sky — HTML/XML domain
tags = {
    tag           = { fg = p.sky_1 },
    builtin       = { fg = p.sky_1 },
    attribute     = { fg = p.sky_3, fmt = "italic" },
    delimiter     = { fg = p.glu_2 },
},

-- @markup.strong                 **bold**
-- @markup.italic                 *italic*
-- @markup.strikethrough          ~~struck~~
-- @markup.underline              underlined text
-- @markup.heading                heading (generic)
-- @markup.heading.1-6            heading levels
-- @markup.quote                  > blockquote
-- @markup.math                   $math$
-- @markup.link                   text references, footnotes
-- @markup.link.label             link descriptions
-- @markup.link.url               URL-style links
-- @markup.raw                    `inline code`
-- @markup.raw.block              ```fenced code blocks```
-- @markup.list                   list markers
-- @markup.list.checked           [x] checked items
-- @markup.list.unchecked         [ ] unchecked items
-- Color: mixed — prose follows typography conventions more than code
markup = {
    strong        = { fmt = "bold" },
    italic        = { fg = p.blu_4, fmt = "italic" },
    strikethrough = { fg = p.slt_4, fmt = "strikethrough" },
    underline     = { fg = p.brt_0, sp = p.brt_2, fmt = "underline" },
    heading       = { fg = p.sky_2, fmt = "bold" },
    heading_1     = { fg = p.sky_2, fmt = "bold" },
    heading_2     = { fg = p.sky_2, fmt = "bold" },
    heading_3     = { fg = p.sky_2, fmt = "bold" },
    heading_4     = { fg = p.sky_2, fmt = "bold" },
    heading_5     = { fg = p.sky_2, fmt = "bold" },
    heading_6     = { fg = p.sky_2, fmt = "bold" },
    quote         = { fg = p.slt_5 },
    math          = { fg = p.sky_1 },
    link          = { fg = p.slt_2 },
    link_label    = { fg = p.sky_1 },
    link_url      = { fg = p.tyr_3 },
    raw           = { fg = p.grn_3 },
    raw_block     = { fg = p.grn_3 },
    list          = { fg = p.glu_2 },
    list_checked  = { fg = p.emr_3 },
    list_unchecked = { fg = p.slt_2 },
},

-- @diff.plus                     added text
-- @diff.minus                    deleted text
-- @diff.delta                    changed text
diff = {
    plus          = { fg = p.tyr_1 },
    minus         = { fg = p.his_1 },
    delta         = { fg = p.sky_2 },
},

-- NvimTree file browser
tree = {
    file    = { fg = p.fg,    bg = p.glc_0 },
    dir     = { fg = p.blu_3, fmt = "bold" },
    symlink = { fg = p.sky_2, fmt = "italic" },
    exec    = { fg = p.orn_3 },
},

-- Miscellaneous (things that don't map to a single treesitter category)
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
