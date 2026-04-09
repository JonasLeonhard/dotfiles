vim.pack.add({
  {
    src = 'https://github.com/esmuellert/codediff.nvim',
  }
})

vim.schedule(function()
  require("codediff").setup({
    diff = { compute_moves = true },
  })
end)
