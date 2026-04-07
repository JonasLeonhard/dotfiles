return {
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown', 'markdown.mdx' },
  root_dir = function(source)
    return vim.fs.root(source, { '.marksman.toml', '.git' })
  end
}
