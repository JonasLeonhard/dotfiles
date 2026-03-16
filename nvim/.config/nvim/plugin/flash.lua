vim.pack.add({
  {
    src = 'https://github.com/folke/flash.nvim',
  }
})

local has_setup = false
local ensure_setup = function()
  if (has_setup) then return end
  has_setup = true

  require('flash').setup({
    modes = {
      search = {
        enabled = false,
      },
      char = {
        label = { exclude = 'hjkliardcwbyog' },
      },
    },
  })
end

vim.keymap.set({ 'n', 'o' }, 's', function()
  ensure_setup()
  require('flash').jump({ search = { mode = 'exact' } })
end, { desc = 'Flash' })

vim.keymap.set('o', 'r', function()
  ensure_setup()
  require('flash').remote({ search = { mode = 'fuzzy' } })
end, { desc = 'Remote Flash' })
