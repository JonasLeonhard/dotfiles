vim.pack.add({
  {
    src = 'https://github.com/nvim-mini/mini.diff',
  }
})
vim.schedule(function()
  require('mini.diff').setup({
    mappings = {
      apply = '',
      -- Reset hunks inside a visual/operator region
      reset = 'gr',
    },
    delay = {
      -- How much to wait before update following every text change
      text_change = 500,
    },
  })

  vim.keymap.set('n', '<leader>gh', function()
    MiniDiff.toggle_overlay()
  end, { desc = 'Diff Show Hunk' })
end)
