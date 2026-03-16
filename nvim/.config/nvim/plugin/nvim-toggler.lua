vim.pack.add({
  {
    src = 'https://github.com/nguyenvukhang/nvim-toggler',
  }
})

vim.schedule(function()
  require('nvim-toggler').setup({
    inverses = {
      ['true'] = 'false',
      ['True'] = 'False',
      ['TRUE'] = 'FALSE',
      ['Yes'] = 'No',
      ['YES'] = 'NO',
      ['UP'] = 'DOWN',
      ['LEFT'] = 'RIGHT',
      ['left'] = 'right',
      ['Left'] = 'Right',
      ['TOP'] = 'BOTTOM',
      ['top'] = 'bottom',
      ['Top'] = 'Bottom',
      ['1'] = '0',
      ['<'] = '>',
      ['('] = ')',
      ['['] = ']',
      ['{'] = '}',
      ['"'] = "'",
      ['+'] = '-',
      ['==='] = '!==',
      ['/'] = '\\',
      ['const'] = 'let',
      ['&&'] = '||',
    },
    remove_default_keybinds = true,
    remove_default_inverses = true,
  })
end)

vim.keymap.set('n', '<leader>ct', function()
  require('nvim-toggler').toggle()
end, { desc = 'Toggle Cursor Alternate' })
