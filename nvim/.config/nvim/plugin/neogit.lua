vim.pack.add({
  {
    src = 'https://github.com/NeogitOrg/neogit',
  }
})

vim.schedule(function()
  require('neogit').setup({
    commit_editor = {
      show_staged_diff = false, -- INFO: Disabled because this freezes neogit for very large commits
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
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  vim.cmd(start_line .. ',' .. end_line .. 'NeogitLogCurrent')
end, { desc = 'Log of current selection' })
