return {
  cmd = { 'twiggy-language-server', '--stdio' },
  filetypes = { 'twig' },
  root_dir = function(source)
    return vim.fs.root(source, { 'composer.json', '.git' })
  end
}
