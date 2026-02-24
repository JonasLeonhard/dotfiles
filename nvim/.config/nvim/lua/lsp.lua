-- LazyLoad all lsp/ server configurations
local lsp_configs = {}
for _, v in ipairs(vim.api.nvim_get_runtime_file('lsp/*', true)) do
  local name = vim.fn.fnamemodify(v, ':t:r');
  table.insert(lsp_configs, name)
end

vim.lsp.enable(lsp_configs)

vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd(string.format('tabnew %s', vim.lsp.log.get_filename()))
end, {
  desc = 'Opens the Nvim LSP client log.',
})

vim.api.nvim_create_user_command('LspInfo', function()
  vim.cmd("checkhealth vim.lsp")
end, {
  desc = 'Opens the Nvim LSP client log.',
})
