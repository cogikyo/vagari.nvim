# Vagari Colorscheme

A **carefully crafted** colorscheme for _Neovim_ with full ~~vim~~ treesitter support.

## Table of Contents

- [Installation](#installation)
- [Features](#features)
- [Configuration](#configuration)
- [Color Palette](#color-palette)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "example/vagari.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("vagari")
  end,
}
```

Or with `packer.nvim`:

```vim
use {
  'example/vagari.nvim',
  config = function()
    vim.cmd [[colorscheme vagari]]
  end
}
```

## Features

### Treesitter Integration

Every `@capture` group gets its own color assignment via the **thalamus** routing system.

### Semantic Tokens

LSP semantic tokens are supported with minimal overrides — treesitter wins by default.

> "Good color design is about constraint, not variety."
>
> — Design principle behind Vagari

### Supported Languages

1. Go
2. TypeScript / TSX
3. Python
4. Lua
5. Shell / Bash

### Task List

- [x] Core palette design
- [x] Treesitter highlight groups
- [x] LSP diagnostic colors
- [ ] Light theme variant
- [ ] Terminal color integration

## Color Palette

| Role     | Color   | Hex       | CR    |
|----------|---------|-----------|-------|
| Types    | Blue    | `#7aa2f7` | 5.12  |
| Function | Orange  | `#ff9e64` | 6.33  |
| Strings  | Green   | `#9ece6a` | 8.15  |
| Keywords | Purple  | `#bb9af7` | 4.66  |
| Errors   | Ruby    | `#f7768e` | 5.42  |
| Numbers  | Pink    | `#e0af68` | 7.29  |

## Configuration

Set options *before* loading the colorscheme:

```typescript
interface VagariOptions {
  italics: boolean;
  bold: boolean;
  contrast: "low" | "medium" | "high";
}
```

### Inline Code

Use `vim.cmd.colorscheme("vagari")` to activate. The palette lives in `lua/vagari/palette.lua`.

## Links and References

- Repository: <https://github.com/example/vagari>
- Issues: [GitHub Issues][issues]
- Documentation: [Wiki](https://github.com/example/vagari/wiki)
- Related: See also [catppuccin] and [tokyonight]

[issues]: https://github.com/example/vagari/issues
[catppuccin]: https://github.com/catppuccin/nvim
[tokyonight]: https://github.com/folke/tokyonight.nvim

---

## Footnotes

This project is inspired by several excellent colorschemes[^1].

[^1]: Including Catppuccin, Tokyo Night, and Gruvbox — each contributing ideas about contrast, color psychology, and semantic grouping.

***

*Last updated: 2024-12-01*
