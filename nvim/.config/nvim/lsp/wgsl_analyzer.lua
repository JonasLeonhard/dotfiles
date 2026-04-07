return {
  cmd = { 'wgsl-analyzer' },
  filetypes = { 'wgsl' },
  root_dir = function(source)
    return vim.fs.root(source, { '.git' })
  end
}
