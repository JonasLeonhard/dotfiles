return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_dir = function(source)
    return vim.fs.root(source, { 'vendor', { 'composer.json', '.git' } });
  end,
}
