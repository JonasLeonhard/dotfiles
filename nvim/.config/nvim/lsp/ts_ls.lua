return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue'
  },
  root_dir = function(source)
    return vim.fs.root(source, { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' })
  end,
  init_options = {
    hostInfo = 'neovim',
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vim.fn.stdpath 'data' .. '/mason/packages' .. "/vue-language-server/node_modules/@vue/language-server",
        languages = { 'vue' },
      },
    },
  },
}
