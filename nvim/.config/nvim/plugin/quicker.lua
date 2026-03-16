vim.pack.add({
  {
    src = 'https://github.com/stevearc/quicker.nvim',
  }
})

local has_setup = false
local ensure_setup = function()
  if has_setup then return end
  has_setup = true
  require('quicker').setup({
    opts = {
      relativenumber = true,
    },
    keys = {
      {
        '<TAB>',
        function()
          require('quicker').expand { before = 2, after = 2, add_to_existing = true }
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<S-TAB>',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
    },
  })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  once = true,
  callback = function() ensure_setup() end,
})

vim.keymap.set('n', '<leader>uq', function()
  ensure_setup(); require('quicker').toggle({ focus = true })
end, { desc = 'Toggle Quicker' })

vim.keymap.set('n', 'gq', function()
  ensure_setup(); vim.cmd('cnext')
end, { desc = 'cnext (Quickfix)' })

vim.keymap.set('n', 'gQ', function()
  ensure_setup(); vim.cmd('cprevious')
end, { desc = 'cprevious (Quickfix)' })
