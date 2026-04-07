return {
  cmd = { 'nu', '--lsp' },
  filetypes = { 'nu' },
  root_dir = function(source)
    return vim.fs.root(source, { '.git' })
  end
}
