return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = function(source)
    vim.fs.root(source, { 'go.work', 'go.mod', '.git' })
  end
}
