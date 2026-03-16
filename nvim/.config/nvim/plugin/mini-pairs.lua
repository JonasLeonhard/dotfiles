vim.pack.add({
  {
    src = 'https://github.com/echasnovski/mini.pairs',
  }
})

vim.schedule(function()
  require("mini.pairs").setup({});
end)
