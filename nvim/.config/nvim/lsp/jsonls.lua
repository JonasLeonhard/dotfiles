return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = {
    provideFormatter = true,
  },
  root_dir = function(source)
    return vim.fs.root(source, { '.git' })
  end
}
