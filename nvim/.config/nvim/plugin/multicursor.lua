vim.pack.add({
  {
    src = 'https://github.com/jake-stewart/multicursor.nvim',
  }
})

vim.schedule(function()
  require("multicursor-nvim").setup({});

  vim.api.nvim_set_hl(0, 'MultiCursorCursor', { link = 'Cursor' })
  vim.api.nvim_set_hl(0, 'MultiCursorVisual', { link = 'Visual' })
  vim.api.nvim_set_hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
  vim.api.nvim_set_hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })

  -- override the default esc handler to clear multicursors(see whichkey.lua)
  vim.keymap.set('n', '<esc>', function()
    print 'esc called...'
    local mc = require 'multicursor-nvim'
    if mc.hasCursors() then
      mc.clearCursors()
    end
    vim.cmd 'noh'
  end, { remap = true })
end)

vim.keymap.set('n', '<leader>vn', function()
  require('multicursor-nvim').matchAddCursor(1)
end, { desc = 'Add cursor and jump to next word' })
vim.keymap.set('n', '<leader>vN', function()
  require('multicursor-nvim').matchAddCursor(-1)
end, { desc = 'Add cursor and jump to prev word' })
vim.keymap.set('n', '<leader>vs', function()
  require('multicursor-nvim').matchSkipCursor(1)
end, { desc = 'Skip cursor and jump to next word' })
vim.keymap.set('n', '<leader>vS', function()
  require('multicursor-nvim').matchSkipCursor(-1)
end, { desc = 'Skip cursor and jump to prev word' })
vim.keymap.set('n', '<leader>vk', function()
  require('multicursor-nvim').addCursor('k')
end, { desc = 'Add cursors above' })
vim.keymap.set('n', '<leader>vj', function()
  require('multicursor-nvim').addCursor('j')
end, { desc = 'Add cursors below' })
vim.keymap.set('n', '<leader>vl', function()
  require('multicursor-nvim').nextCursor()
end, { desc = 'Rotate to next cursor' })
vim.keymap.set('n', '<leader>vh', function()
  require('multicursor-nvim').prevCursor()
end, { desc = 'Rotate to prev cursor' })
vim.keymap.set('n', '<leader>va', function()
  require('multicursor-nvim').alignCursors()
end, { desc = 'Align cursor columns' })
vim.keymap.set('n', '<leader>vt', function()
  require('multicursor-nvim').transposeCursors(1)
end, { desc = 'Rotate visual selection contents' })
vim.keymap.set('n', '<leader>vT', function()
  require('multicursor-nvim').transposeCursors(-1)
end, { desc = 'Rotate visual selection contents (-1)' })
vim.keymap.set('v', 'S', function()
  require('multicursor-nvim').splitCursors()
end, { desc = 'Split cursors' })
vim.keymap.set('v', 'M', function()
  require('multicursor-nvim').matchCursors()
end, { desc = 'Match cursors' })
vim.keymap.set('v', 'I', function()
  require('multicursor-nvim').insertVisual()
end, { desc = 'Insert visual' })
vim.keymap.set('v', 'A', function()
  require('multicursor-nvim').appendVisual()
end, { desc = 'Append visual' })
vim.keymap.set('v', 'v', function()
  require('multicursor-nvim').visualToCursors()
end, { desc = 'Visual to cursors' })
vim.keymap.set('n', '<leader>vq', function()
  local mc = require('multicursor-nvim')
  if mc.cursorsEnabled() then mc.disableCursors() else mc.enableCursors() end
end, { desc = 'Toggle multicursor mode' })
