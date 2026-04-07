return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_dir = vim.fs.root(0, { 'vendor', { 'composer.json', '.git' } }),
}
