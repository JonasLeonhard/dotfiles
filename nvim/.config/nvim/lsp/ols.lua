return {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  root_dir = function(source)
    return vim.fs.root(source, { 'ols.json', '.git', '.odin' })
  end,
  init_options = {
    checker_args = "-strict-style -vet -debug",
  },
}
