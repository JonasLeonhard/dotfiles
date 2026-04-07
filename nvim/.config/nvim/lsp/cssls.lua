return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_dir = function(source)
    return vim.fs.root(source, {
      'package.json',
      '.git'
    })
  end,
  init_options = { provideFormatter = true },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}
