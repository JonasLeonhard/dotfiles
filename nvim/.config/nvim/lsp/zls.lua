return {
  cmd = { 'zls' },
  filetypes = { 'zig', 'zir' },
  root_dir = function(source)
    return vim.fs.root(source, { 'zls.json', 'build.zig', '.git' })
  end,
  settings = {
    enable_build_on_save = true,
    build_on_save_step = 'check',
  },
}
