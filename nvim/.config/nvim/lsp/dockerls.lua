return {
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
  root_dir = function(source)
    return vim.fs.root(source, { 'Dockerfile' })
  end
}
