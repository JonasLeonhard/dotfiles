vim.pack.add({
  {
    src = 'https://github.com/stevearc/conform.nvim',
  }
})

local has_setup = false
local ensure_setup = function()
  if has_setup then return end
  has_setup = true
  vim.cmd.packadd('conform.nvim')

  local conform = require 'conform'

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  -- Custom formatter configuration
  conform.formatters.djlint = {
    args = {
      '--reformat',
      '--preserve-blank-lines',
      '--line-break-after-multiline-tag',
      '--indent',
      '2',
      '-',
    },
  }

  -- Main setup
  conform.setup({
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
      css = { 'prettierd', 'prettier', stop_after_first = true },
      graphql = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettierd', 'prettier', stop_after_first = true },
      lua = { 'stylua', stop_after_first = true },
      python = { 'isort', 'black', stop_after_first = true },
      scss = { 'prettierd', 'prettier', stop_after_first = true },
      svelte = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      vue = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      twig = { 'djlint' },
      astro = { 'prettierd', 'prettier', stop_after_first = true },
      odin = { 'odinfmt' }
    },
    format_after_save = function()
      if not _AutoFormatEnabled() then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback", }
    end,
  })
end

vim.api.nvim_create_autocmd('BufWritePre', {
  once = true,
  callback = function()
    ensure_setup()
  end
})
