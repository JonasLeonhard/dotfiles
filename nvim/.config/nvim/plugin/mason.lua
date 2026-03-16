vim.pack.add({
  {
    src = 'https://github.com/williamboman/mason.nvim',
  }
})

local has_setup = false
local ensure_setup = function()
  if has_setup then return end

  require('mason').setup({
    -- !INFO: mason automatically prepends all installed binaries to the path!
    install_root_dir = vim.fn.stdpath 'data' .. '/mason',

    -- INFO: for some shells this wont append to the path correctly (eg. nushell).
    -- in these cases: please add ( := vim.fn.stdpath 'data' .. '/mason/bin' ) to your shell path.
    -- This way neovim will be able to find all installed binaries from mason
    PATH = 'prepend',
  })
end

for _, cmd in ipairs({ 'Mason', 'MasonUpdate', 'MasonInstall', 'MasonUninstall' }) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    ensure_setup()
    vim.cmd(cmd .. (opts.args ~= '' and ' ' .. opts.args or ''))
  end, { nargs = '*', desc = 'Lazy load mason' })
end
