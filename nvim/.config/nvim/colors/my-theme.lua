vim.g.colors_name = 'my-theme'
vim.opt.termguicolors = true -- True color support

local colors = {
  red = "#f38ba8",
  redDark = "#331d23", -- TODO
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  greenDark = "#121912", -- TODO
  blue = "#89b4fa",
  text = "#D8D8D8",
  text2 = "#e8e8ea",
  subtext0 = "#dbdbde",
  overlay1 = "#7f849c",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = '#0a0a0a',
  mantle = '#121212',
}

vim.cmd('highlight clear')
if vim.fn.exists('syntax') then
  vim.cmd('syntax reset')
end

-- =============================================================================
-- | Editor
-- =============================================================================

vim.api.nvim_set_hl(0, 'Normal', { fg = colors.text, bg = colors.base })
vim.api.nvim_set_hl(0, 'Cursor', { bg = colors.text, fg = colors.base })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = colors.mantle })
vim.api.nvim_set_hl(0, 'Visual', { bg = colors.surface1 })
vim.api.nvim_set_hl(0, 'Search', { bg = colors.yellow, fg = colors.base })
vim.api.nvim_set_hl(0, 'IncSearch', { bg = colors.peach, fg = colors.base })
vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.surface0 })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = colors.yellow })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = colors.base })
vim.api.nvim_set_hl(0, 'VertSplit', { fg = colors.surface0, bg = colors.base })
vim.api.nvim_set_hl(0, 'StatusLine', { fg = colors.surface0, bg = colors.base })
vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = colors.surface0, bg = colors.base })
vim.api.nvim_set_hl(0, 'WildMenu', { bg = colors.yellow, fg = colors.base })
vim.api.nvim_set_hl(0, 'Pmenu', { fg = colors.text, bg = colors.mantle })
vim.api.nvim_set_hl(0, 'PmenuSel', { fg = colors.base, bg = colors.yellow })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = colors.mantle })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = colors.surface0 })
vim.api.nvim_set_hl(0, 'TabLine', { bg = colors.mantle, fg = colors.overlay1 })
vim.api.nvim_set_hl(0, 'TabLineSel', { fg = colors.yellow, bg = colors.surface0 })
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = colors.mantle })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = colors.surface0 })
vim.api.nvim_set_hl(0, 'Folded', { fg = colors.overlay1, bg = colors.mantle })
vim.api.nvim_set_hl(0, 'Whitespace', { fg = colors.surface0 })
vim.api.nvim_set_hl(0, 'NonText', { fg = colors.overlay1, italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = colors.red, italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = colors.blue, italic = true })

vim.api.nvim_set_hl(0, 'DiffAdd', { bg = colors.greenDark })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = colors.blue })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = colors.redDark })
vim.api.nvim_set_hl(0, 'DiffText', { bg = colors.blue })

-- =============================================================================
-- | Syntax
-- =============================================================================

-- Ordered by importance:

-- 1. CONTROL FLOW & Important (colored - yellow, bold)
vim.api.nvim_set_hl(0, 'Statement', { fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, 'Conditional', { fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, 'Repeat', { fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, 'Label', { fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, 'Keyword', { fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, 'Exception', { fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, 'Special', { fg = colors.yellow, italic = true })
vim.api.nvim_set_hl(0, 'Directory', { fg = colors.yellow, italic = true })

-- 2. VARIABLES & FUNCTIONS (bold, italic, slightly whiter)
vim.api.nvim_set_hl(0, 'Identifier', { fg = colors.text2, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Function', { fg = colors.text2, bold = true, italic = true })

-- 3. CONSTANTS, NUMBERS (bold, italic)
vim.api.nvim_set_hl(0, 'Constant', { fg = colors.text2, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Number', { fg = colors.text2, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Boolean', { fg = colors.text2, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Float', { fg = colors.text2, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'Character', { fg = colors.text2, bold = true, italic = true })
vim.api.nvim_set_hl(0, 'String', { fg = colors.text2, italic = true })

-- 4. TYPE, INCLUDE, COMMENT (italic)
vim.api.nvim_set_hl(0, 'Type', { fg = colors.text, italic = true })
vim.api.nvim_set_hl(0, 'PreProc', { fg = colors.text, italic = true })
vim.api.nvim_set_hl(0, 'Include', { fg = colors.text, italic = true })
vim.api.nvim_set_hl(0, 'Define', { fg = colors.text, italic = true })
vim.api.nvim_set_hl(0, 'Macro', { fg = colors.text, italic = true })

-- 5. LESS IMPORTANT COMMENTS (special color - overlay1)
vim.api.nvim_set_hl(0, 'Comment', { fg = colors.overlay1, italic = true })

-- 6. LOGIC (normal text color)
vim.api.nvim_set_hl(0, 'Operator', { fg = colors.text })
vim.api.nvim_set_hl(0, 'Structure', { fg = colors.text })

-- =============================================================================
-- | Plugin: Oil
-- =============================================================================
vim.api.nvim_set_hl(0, 'OilFile', { fg = colors.text2, italic = true })
vim.api.nvim_set_hl(0, 'OilDir', { fg = colors.yellow, italic = true })

-- =============================================================================
-- | Plugin: Neogit
-- =============================================================================
vim.api.nvim_set_hl(0, 'NeogitSectionHeader', { fg = colors.yellow, italic = true })

-- =============================================================================
-- | Plugin: Snacks
-- =============================================================================
vim.api.nvim_set_hl(0, 'SnacksPicker', { link = 'Normal' })

-- =============================================================================
-- | Plugin: Gitsigns
-- =============================================================================
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = colors.green })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = colors.yellow })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = colors.red })
vim.api.nvim_set_hl(0, 'GitSignsAddPreview', { link = "DiffAdd" })
vim.api.nvim_set_hl(0, 'GitSignsDeletePreview', { link = "DiffDelete" })
vim.api.nvim_set_hl(0, 'MoreMsg', { link = "IncSearch" })
vim.api.nvim_set_hl(0, 'Title', { link = "Normal" })
