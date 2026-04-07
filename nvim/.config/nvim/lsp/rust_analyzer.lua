return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_dir = function(source)
    return vim.fs.root(source, { 'Cargo.toml', '.git' })
  end,
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true,
      },
      checkOnSave = true,
      check = {
        enable = true,
        command = 'clippy',
        features = 'all',
      },
      procMacro = {
        enable = true,
      },
    }
  }

}
