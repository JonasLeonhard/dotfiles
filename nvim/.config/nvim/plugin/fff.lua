vim.pack.add({
  {
    src = 'https://github.com/dmtrKovalenko/fff',
  }
})

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = false, show_scores = true },
  prompt = '> ',
  prompt_vim_mode = true,
  layout = {
    height = 0.65,
    width = 1,
    prompt_position = 'top',    -- or 'top'
    preview_position = 'right', -- 'left' | 'right' | 'top' | 'bottom'
    preview_size = 0.5,
    -- Border style for the picker windows. Leave unset (nil) to follow the
    -- global `vim.o.winborder`; set it to override fff's borders independently.
    border = 'none',                         -- 'single' | 'double' | 'rounded' | 'solid' | 'shadow' | 'none'
    flex = { size = 130, wrap = 'top' },
    min_list_height = 10,                    --  do not display anything except the list below this threshold
    show_scrollbar = true,
    path_shorten_strategy = 'middle_number', -- 'middle_number' | 'middle' | 'end' | 'start'
    anchor = 'bottom',
  },
  keymaps = {
    close = '<Esc>',
    select = '<CR>',
    select_split = '<C-s>',
    select_vsplit = '<C-v>',
    select_tab = '<C-t>',
    move_up = { '<Up>', '<C-k>' },
    move_down = { '<Down>', '<C-j>' },
    preview_scroll_up = '<C-u>',
    preview_scroll_down = '<C-d>',
    toggle_debug = '<leader>ud',
    cycle_grep_modes = '<S-Tab>',
    -- grep mode only: jump cursor to first match of next/prev file group
    grep_jump_to_next_file = { '<C-A-n>', '<A-Down>' },
    grep_jump_to_prev_file = { '<C-A-p>', '<A-Up>' },
    cycle_previous_query = '<C-Up>',
    toggle_select = '<Tab>',
    send_to_quickfix = '<C-q>',
    focus_list = '<leader>l',
    focus_preview = '<leader>p',
  },
}

vim.keymap.set('n', '<leader>f', function() require('fff').find_files() end, { desc = 'FFFind files' })
vim.keymap.set('n', '<leader>sg', function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end,
  { desc = 'FFF live grep' })
