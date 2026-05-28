vim.pack.add({
  {
    src = 'https://github.com/NeogitOrg/neogit',
  }
})

vim.schedule(function()
  require('neogit').setup({
    commit_editor = {
      show_staged_diff = false, -- INFO: Disabled because this freezes neogit for very large commits
    },
    sections = {
      stashes = {
        folded = true,
        hidden = true, -- INFO: for better startup performance i will not load the stashes list at all. When you have a somewhat large list of stashes (eg. 17) this causes noticable lag after opening the neogit menu. You can still access stashes with 'Z'
      },
    }
  })
end)

vim.keymap.set('n', '<leader>gg', function()
  vim.cmd('Neogit')
end, { desc = 'Neogit' })

vim.keymap.set('n', '<leader>gl', function()
  vim.cmd('NeogitLogCurrent')
end, { desc = 'Log of current file' })

vim.keymap.set('v', '<leader>gl', function()
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  -- Ensure start_line is always the smaller number (if you selected bottom-up)
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local file = vim.fn.expand('%:p')
  local range_arg = start_line .. ',' .. end_line .. ':' .. file

  require('neogit').action('log', 'log_current', { '-L', range_arg })()
end, { desc = 'Neogit log of current selection' })
