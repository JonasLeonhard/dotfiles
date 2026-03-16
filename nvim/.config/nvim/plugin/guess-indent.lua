vim.pack.add({
  {
    src = 'https://github.com/nmac427/guess-indent.nvim',
  }
})

vim.schedule(function()
  require("guess-indent").setup({
    auto_cmd = true
  })
end)
