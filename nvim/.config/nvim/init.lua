-- Plugins are installed using ':h vim.pack':
-- looking for plugins? they are automatically loaded in /plugin
-- If you want to update plugins: ':h vim.pack' or update via ":= vim.pack.update()", :w the buffer to confirm updates

-- ### Configure builtin neovim options: ###############################################################################
vim.cmd.colorscheme 'my-theme' -- loads custom theme from colors/my-theme.lua

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt
opt.synmaxcol = 500           -- disable "set syntax" for large files for better performance
opt.breakindent = true        -- keep same indentation after break
opt.autowrite = true          -- Enable auto write
opt.clipboard = 'unnamedplus' -- Sync with system clipboard
opt.conceallevel = 2          -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true            -- Confirm to save changes before exiting modified buffer
opt.cursorline = true         -- Enable highlighting of the current line
opt.expandtab = true          -- Use spaces instead of tabs
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true     -- Ignore case
opt.list = true           -- Show some invisible characters (tabs...
opt.number = true         -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4         -- Lines of context
opt.shiftround = true     -- Round indent
opt.shiftwidth = 2        -- Size of an indent
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.showmode = false      -- Dont show mode since we have a statusline
opt.signcolumn = 'yes'    -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartindent = true    -- Insert indents automatically
opt.tabstop = 2           -- Number of spaces tabs count for
opt.undofile = true
opt.undolevels = 10000
opt.virtualedit = 'block'           -- Allow cursor to move where there is no text in visual block mode
opt.wrap = false                    -- Disable line wrap
opt.ch = 0;                         -- no command line height
opt.splitright = true               -- Put new windows right of current (eg :InspectTree)
opt.splitbelow = true               -- Put new windows below current
require('vim._core.ui2').enable({}) -- :h ui2
opt.laststatus = 3
opt.nrformats = 'bin,hex,alpha,octal,'

-- Folding
vim.o.foldmethod = "manual"
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldtext = '' -- keep the treesitter syntax highlighting for folds

-- ### Filetype's: #########################################################################################
vim.filetype.add({
  extension = {
    svx = "markdown"
  }
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  once = true,
  callback = function()
    vim.cmd.packadd('cfilter') -- enable builtin ':Cfilter' quickfix filtering command
  end,
})

-- ### Diagnostic's: #######################################################################################
vim.diagnostic.config {
  float = {
    source = true,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = '󰋼 ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
  },
  underline = true,
  update_in_insert = false,
  virtual_text = {
    prefix = ' ', -- icon for diagnostic message
  },
}

-- ### Treesitter: ###################################################################################################
-- :h treesitter (install to parser/{lang}.* & queries/{lang}/highlights.scm)
-- 1. git clone https://github.com/tree-sitter/tree-sitter
-- 2. install treesitter from the repo: cargo install --path crates/cli
-- 3. look for a parser to install and clone it: https://github.com/tree-sitter/tree-sitter/wiki/List-of-parsers
-- 4. tree-sitter generate; make all
-- 5. Move the parsers: 'cp libtree-sitter-javascript.dylib ~/.config/nvim/parser/javascript.dylib'
-- 6. Move the queries: 'mkdir ~/.config/nvim/queries/javascript; cp queries/*.scm ~/.config/nvim/queries/javascript/'
--
-- Use :InspectTree to check if the parser is working!
--
-- If your language queries extend another language (like tsx): add this at the top of each .scm file
-- ;; inherits: javascript
-- ;; inherits: typescript
--
-- If your filetypes dont match the parser name: vim.treesitter.language.register('tsx', 'typescriptreact')
vim.treesitter.language.register('tsx', 'typescriptreact')
vim.treesitter.language.register('tsx', 'javascriptreact')

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    vim.bo.autoindent = true -- use autoindent instead of treesitter indentation (treesitter turns this off after starting)
  end,
})

-- ### Command's: ##############################################################################################
-- ToggleAutoFormat command
local autoformatting_on = true

vim.api.nvim_create_user_command('ToggleAutoFormat', function()
  autoformatting_on = not autoformatting_on
  vim.api.nvim_command 'doautocmd User AutoFormatToggled'
end, {})

_AutoFormatEnabled = function()
  return autoformatting_on
end

vim.api.nvim_create_user_command('ToggleInlayHints', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, {})


-- Autocmd's:
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.hl_op { higroup = 'YankHighlight', timeout = 220 }
  end,
  group = highlight_group,
  pattern = '*',
})
vim.cmd [[highlight YankHighlight guifg=#000000 guibg=#FAB387 gui=nocombine]]

-- ### Import LSP Data: #################################################################################################
-- & LazyLoad all lsp/ server configurations
local lsp_configs = {}
for _, v in ipairs(vim.api.nvim_get_runtime_file('lsp/*', true)) do
  local name = vim.fn.fnamemodify(v, ':t:r');
  table.insert(lsp_configs, name)
end

vim.lsp.enable(lsp_configs)

vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd(string.format('tabnew %s', vim.lsp.log.get_filename()))
end, {
  desc = 'Opens the Nvim LSP client log.',
})

vim.api.nvim_create_user_command('LspInfo', function()
  vim.cmd("checkhealth vim.lsp")
end, {
  desc = 'Opens the Nvim LSP client log.',
})

--- ### Listchar (highlighting specific chars): #######################################################################
--- This file adds custom highlighting for specific listchars in red, for example NonBreakingSpace and TralingSpaceChar
local highlightThemeColors = {
  red = "#F38BA8"
}

-- highlight listchars (non whitespace, trailing whitespace, tab) :h listchars :h list
vim.opt.listchars = "tab:  ,trail:·,nbsp:·"

local highlightListchars = function()
  local filename = vim.fn.expand('%');

  -- skip highlighting for non-files (eg- alpha dashboard.)
  if (filename == '' or vim.bo.buftype == 'terminal' or vim.bo.buftype == 'nofile') then
    return
  end

  -- https://vim.fandom.com/wiki/Highlight_unwanted_spaces#Highlighting_with_the_match_command
  vim.cmd [[ syntax match NBSP " " ]] -- <-- INFO: this is a unicode nbsp character
  vim.cmd [[ syntax match TrailingSpaceChar /\s\+$/ ]]
  vim.api.nvim_set_hl(0, "NBSP",
    { fg = "White", bg = highlightThemeColors.red })
  vim.api.nvim_set_hl(0, "TrailingSpaceChar",
    { fg = "White", bg = highlightThemeColors.red })
end


local deHighlightListchars = function()
  -- https://vim.fandom.com/wiki/Highlight_unwanted_spaces#Highlighting_with_the_match_command
  vim.api.nvim_set_hl(0, "NBSP", {})
  vim.api.nvim_set_hl(0, "TrailingSpaceChar", {})
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = highlightListchars
})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = deHighlightListchars
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = highlightListchars
})

-- ### Terminal config: ################################################################################################
-- :h terminal
-- Disable line numbers in terminal
vim.cmd([[autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no]])
-- Start in insert mode in terminal
vim.cmd([[autocmd TermOpen * startinsert]])

-- keymap for the terminal only: C-w to enter vim mode
vim.cmd 'autocmd! TermOpen term://* lua _Set_terminal_keymaps()'
function _Set_terminal_keymaps()
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], { buffer = 0 })
end

-- ### Nushell support: ##################################################################################################
-- This will add support for tempfiles and rusing stuff like ":r! ls"
-- credits: https://www.kiils.dk/en/blog/2024-06-22-using-nushell-in-neovim/
vim.o.shell = "nu"
if string.match(vim.o.shell, '/nu$') then
  -- INFO: disable the usage of temp files for shell commands
  -- because Nu doesn't support `input redirection` which Neovim uses to send buffer content to a command:
  --      `{shell_command} < {temp_file_with_selected_buffer_content}`
  -- When set to `false` the stdin pipe will be used instead.
  -- NOTE: some info about `shelltemp`: https://github.com/neovim/neovim/issues/1008
  vim.opt.shelltemp = false

  -- string to be used to put the output of shell commands in a temp file
  -- 1. when 'shelltemp' is `true`
  -- 2. in the `diff-mode` (`nvim -d file1 file2`) when `diffopt` is set
  --    to use an external diff command: `set diffopt-=internal`
  vim.opt.shellredir = "out+err> %s"

  -- flags for nu:
  -- * `--stdin`       redirect all input to -c
  -- * `--no-newline`  do not append `\n` to stdout
  -- * `--commands -c` execute a command
  vim.opt.shellcmdflag = "--stdin --no-newline -c"

  -- disable all escaping and quoting
  vim.opt.shellxescape = ""
  vim.opt.shellxquote = ""
  vim.opt.shellquote = ""

  -- string to be used with `:make` command to:
  -- 1. save the stderr of `makeprg` in the temp file which Neovim reads using `errorformat` to populate the `quickfix` buffer
  -- 2. show the stdout, stderr and the return_code on the screen
  -- NOTE: `ansi strip` removes all ansi coloring from nushell errors
  vim.opt.shellpipe =
  '| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record'
end

-- ### Toggler ####################################################################################################################
-- Toggle stuff with a keybind. Eg 'true' <-> 'false' and vice versa.
local toggle_pairs = {
  ['true'] = 'false',
  ['True'] = 'False',
  ['TRUE'] = 'FALSE',
  ['Yes'] = 'No',
  ['YES'] = 'NO',
  ['UP'] = 'DOWN',
  ['LEFT'] = 'RIGHT',
  ['left'] = 'right',
  ['Left'] = 'Right',
  ['TOP'] = 'BOTTOM',
  ['top'] = 'bottom',
  ['Top'] = 'Bottom',
  ['1'] = '0',
  ['<'] = '>',
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
  ['"'] = "'",
  ['+'] = '-',
  ['==='] = '!==',
  ['/'] = '\\',
  ['const'] = 'let',
  ['&&'] = '||',
}

local toggles_two_way = {}
vim.schedule(function()
  for k, v in pairs(toggle_pairs) do
    toggles_two_way[k] = v
    toggles_two_way[v] = k
  end
end)

vim.keymap.set('n', '<leader>ct', function()
  local word = vim.fn.expand('<cword>')

  if toggles_two_way[word] then
    local keys = vim.api.nvim_replace_termcodes('"_ciw' .. toggles_two_way[word] .. '<Esc>', true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
  else
    -- this handles adjacent symbols (e.g., `({`)
    local col = vim.fn.col('.')
    local char = vim.fn.getline('.'):sub(col, col)
    if toggles_two_way[char] then
      vim.api.nvim_feedkeys('r' .. toggles_two_way[char], 'n', false)
    end
  end
end, { desc = 'Toggle Cursor Alternate' })

--- ### Override Neovim's default UI select to be a normal buffer that you can click enter on
vim.ui.select = function(items, opts, on_choice)
  -- Setup fallback formatting if none is provided
  local format_item = opts.format_item or tostring

  -- Save the window you came from so we can forcefully return to it
  local original_win = vim.api.nvim_get_current_win()

  -- Create a temporary, unlisted scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })

  -- Populate the buffer
  local lines = {}
  for _, item in ipairs(items) do
    table.insert(lines, format_item(item))
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

  local height = math.min(10, #lines)

  local row = vim.o.lines - height - vim.o.cmdheight

  local win_opts = {
    relative = 'editor',
    width = vim.o.columns,
    height = height,
    row = row,
    col = 0,
    border = { "", "-", "", "", "", "", "", "" },
    title = opts.prompt or " Select ",
    title_pos = "left", -- "left" aligns nicely when stretched full-width
  }

  -- Open the float and automatically shift focus to it
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Helper function to safely tear down the UI and return focus
  local close_menu = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_win_is_valid(original_win) then
      vim.api.nvim_set_current_win(original_win)
    end
  end

  -- Setup the <CR> (Enter) mapping to confirm selection
  vim.keymap.set('n', '<CR>', function()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local row_idx = cursor[1]
    local selected_item = items[row_idx]

    close_menu()

    if selected_item then
      on_choice(selected_item, row_idx)
    else
      on_choice(nil, nil)
    end
  end, { buffer = buf, nowait = true, desc = "Confirm selection" })

  -- Setup 'q' and <Esc> to cancel out of the menu easily
  local cancel = function()
    close_menu()
    on_choice(nil, nil)
  end
  vim.keymap.set('n', 'q', cancel, { buffer = buf, nowait = true, desc = "Cancel selection" })
  vim.keymap.set('n', '<Esc>', cancel, { buffer = buf, nowait = true, desc = "Cancel selection" })
end
