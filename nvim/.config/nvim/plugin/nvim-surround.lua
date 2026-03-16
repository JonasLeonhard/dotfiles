vim.pack.add({
  {
    src = "https://github.com/kylechui/nvim-surround",
  }
})

vim.schedule(function()
  require("nvim-surround").setup()
end)

vim.keymap.set('v', 's', '<Plug>(nvim-surround-visual)', { desc = 'Add a surrounding pair around a visual selection' })
