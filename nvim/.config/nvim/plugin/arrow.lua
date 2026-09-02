vim.pack.add({
  { src = 'https://github.com/otavioschwanck/arrow.nvim' },
})

local has_setup = false
local ensure_setup = function()
  if has_setup then return end
  has_setup = true

  require('arrow').setup({
    global_bookmarks = true,
    show_icons = true,
    leader_key = '<C-p>',
    buffer_leader_key = 'm',
    mappings = {
      edit = 'e',
      delete_mode = 'd',
      clear_all_items = 'C',
      toggle = 's',
      open_vertical = 'v',
      open_horizontal = '-',
      quit = 'q',
      remove = 'x',
      next_item = 'j',
      prev_item = 'k',
    },
  })
  _G.plugin_arrow_loaded = true -- Fixed the syntax here
end

vim.keymap.set({ 'v', 'n' }, 'm', function()
  ensure_setup()
  require('arrow.persist').toggle()
end, { desc = 'Arrow toggle' })

vim.keymap.set('n', '<C-p>', function()
  ensure_setup()
  require('arrow.ui').openMenu()
end, { desc = 'Arrow menu' })
