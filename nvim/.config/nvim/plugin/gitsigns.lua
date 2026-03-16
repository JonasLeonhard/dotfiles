vim.pack.add({
  {
    src = 'https://github.com/lewis6991/gitsigns.nvim',
  }
}, { load = function() end }) -- it seemed like gitsigns is heavy when loading for me, defer packadd after startup
vim.schedule(function()
  vim.cmd(":packadd gitsigns.nvim")

  require('gitsigns').setup({})

  vim.keymap.set('n', '<leader>g]', function()
    if vim.wo.diff then
      return ']c'
    end
    vim.schedule(function()
      require('gitsigns').next_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Jump to next hunk' })

  vim.keymap.set('n', '<leader>g[', function()
    if vim.wo.diff then
      return '[c'
    end
    vim.schedule(function()
      require('gitsigns').prev_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Jump to prev hunk' })

  vim.keymap.set('n', '<leader>gr', function()
    require('gitsigns').reset_hunk()
  end, { desc = 'Reset hunk' })

  vim.keymap.set('n', '<leader>gh', function()
    require('gitsigns').preview_hunk()
  end, { desc = 'Preview hunk' })

  vim.keymap.set('n', '<leader>gb', function()
    require('gitsigns').blame_line { full = true }
  end, { desc = 'Blame line' })

  vim.keymap.set('n', '<leader>gB', function()
    require('gitsigns').blame()
  end, { desc = 'Blame Menu' })

  vim.keymap.set('n', '<leader>ugd', function()
    require('gitsigns').toggle_deleted()
  end, { desc = 'GitSigns Toggle deleted' })

  vim.keymap.set('n', '<leader>sS', '<cmd>Gitsigns setqflist<cr>', { desc = 'GitSigns qflist' })

  vim.keymap.set('n', '[S', '<cmd>Gitsigns prev_hunk<cr>', { desc = 'GitSigns prev_hunk' })

  vim.keymap.set('n', ']S', '<cmd>Gitsigns next_hunk<cr>', { desc = 'GitSigns next_hunk' })

  vim.keymap.set('n', '<leader>gd', '<cmd>Gitsigns diffthis<cr>', { desc = 'GitSigns diffthis' })
end)
