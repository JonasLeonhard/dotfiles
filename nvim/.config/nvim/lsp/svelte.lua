return {
  cmd = { 'svelteserver', '--stdio' },
  filetypes = { 'svelte' },
  root_markers = function(source)
    return vim.fs.root(source, { 'package.json', '.git' })
  end
}
