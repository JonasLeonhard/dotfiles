vim.pack.add({
  {
    src = "https://github.com/folke/snacks.nvim",
  }
})

local has_setup = false
local ensure_setup = function()
  if (has_setup) then return end
  has_setup = true

  local multiSendToQfConfirm = function(picker, item, action)
    local selected = picker:selected()
    if #selected > 1 then
      Snacks.picker.actions.qflist(picker)
      picker:close()
    else
      Snacks.picker.actions.jump(picker, item, action)
    end
  end

  Snacks.toggle.profiler():map("<leader>up")
  Snacks.toggle.profiler_highlights():map("<leader>uP")

  Snacks.setup {
    bigfile = {},
    picker = {
      prompt = "",
      hidden = true,
      ui_select = true,
      auto_close = false,
      layout = { preset = "ivy" },
      layouts = {
        ivy = {
          reverse = true,
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.4,
            border = "none",
            title = " {title} {live} {flags}",
            title_pos = "left",
            {
              box = "horizontal",
              { win = "list",    border = "none" },
              { win = "preview", title = "{preview}", width = 0.4, border = "none" },
            },
            { win = "input", height = 1, border = "none" },
          },
        }
      },
      sources = {
        select = {
          layout = { preset = "ivy" }, -- This ensures ui_select uses your ivy layout
        },
        grep = {
          confirm = multiSendToQfConfirm
        },
        files = {
          confirm = multiSendToQfConfirm
        },
        smart = {
          confirm = multiSendToQfConfirm
        },
        git_files = {
          confirm = multiSendToQfConfirm
        },
        recent = {
          confirm = multiSendToQfConfirm
        },
        buffers = {
          confirm = multiSendToQfConfirm
        },
        lines = {
          confirm = multiSendToQfConfirm
        },
        grep_buffers = {
          confirm = multiSendToQfConfirm
        },
        diagnostic = {
          confirm = multiSendToQfConfirm
        },
        diagnostics_buffer = {
          confirm = multiSendToQfConfirm
        },
        jumps = {
          confirm = multiSendToQfConfirm
        },
        marks = {
          confirm = multiSendToQfConfirm
        },
        lsp_definitions = {
          confirm = multiSendToQfConfirm
        },
        lsp_declarations = {
          confirm = multiSendToQfConfirm
        },
        lsp_references = {
          confirm = multiSendToQfConfirm
        },
        lsp_implementation = {
          confirm = multiSendToQfConfirm
        },
        lsp_type_definitions = {
          confirm = multiSendToQfConfirm
        },
        lsp_symbols = {
          confirm = multiSendToQfConfirm
        },
        lsp_workspace_symbols = {
          confirm = multiSendToQfConfirm
        }
      },
      win = {
        -- input window
        input = {
          keys = {
            ["∂"] = { "inspect", mode = { "n", "i" }, desc = false, }, -- alt-d
            ["ƒ"] = { "toggle_follow", mode = { "i", "n" }, desc = false }, -- alt-f
            ["ª"] = { "toggle_hidden", mode = { "i", "n" }, desc = false }, --alt-h
            ["⁄"] = { "toggle_ignored", mode = { "i", "n" }, desc = false }, --alt-i
            ["µ"] = { "toggle_maximize", mode = { "i", "n" }, desc = false }, --alt-m
            ["π"] = { "toggle_preview", mode = { "i", "n" }, desc = false }, --alt-p
            ["<C-b>"] = { "select_all", mode = { "n", "i" }, desc = false },
            ["∑"] = { "cycle_win", mode = { "n", "i" }, desc = false }, --alt-w
          },
        },
        list = {
          keys = {
            ["∂"] = { "inspect", mode = { "n", "i" }, desc = false }, -- alt-d
            ["ƒ"] = { "toggle_follow", mode = { "i", "n" }, desc = false }, -- alt-f
            ["ª"] = { "toggle_hidden", mode = { "i", "n" }, desc = false }, --alt-h
            ["⁄"] = { "toggle_ignored", mode = { "i", "n" }, desc = false }, --alt-i
            ["µ"] = { "toggle_maximize", mode = { "i", "n" }, desc = false }, --alt-m
            ["π"] = { "toggle_preview", mode = { "i", "n" }, desc = false }, --alt-p
            ["<C-b>"] = { "select_all", mode = { "n", "i" }, desc = false },
            ["∑"] = { "cycle_win", mode = { "n", "i" }, desc = false }, --alt-w
          },
        },
      },
    },
  }
end
vim.schedule(function()
  ensure_setup()
end)

vim.keymap.set('n', '<leader>f', function()
  ensure_setup(); Snacks.picker.smart()
end, { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader>sb', function()
  ensure_setup(); Snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>sP', function()
  ensure_setup(); Snacks.picker.pickers()
end, { desc = 'Pickers' })
-- find
vim.keymap.set('n', '<leader>sf', function()
  ensure_setup(); Snacks.picker.files()
end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>sG', function()
  ensure_setup(); Snacks.picker.git_files()
end, { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>sr', function()
  ensure_setup(); Snacks.picker.recent()
end, { desc = 'Recent' })
-- grep
vim.keymap.set('n', '<leader>sl', function()
  ensure_setup(); Snacks.picker.lines()
end, { desc = 'Buffer Lines' })
vim.keymap.set('n', '<leader>sB', function()
  ensure_setup(); Snacks.picker.grep_buffers()
end, { desc = 'Grep Open Buffers' })
vim.keymap.set('n', '<leader>sg', function()
  ensure_setup(); Snacks.picker.grep()
end, { desc = 'Grep' })
-- search
vim.keymap.set('n', '<leader>sD', function()
  ensure_setup(); Snacks.picker.diagnostics()
end, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>s<C-d>', function()
  ensure_setup(); Snacks.picker.diagnostics_buffer()
end, { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>sj', function()
  ensure_setup(); Snacks.picker.jumps()
end, { desc = 'Jumps' })
vim.keymap.set('n', '<leader>sL', function()
  ensure_setup(); Snacks.picker.loclist()
end, { desc = 'Location List' })
vim.keymap.set('n', '<leader>sm', function()
  ensure_setup(); Snacks.picker.marks()
end, { desc = 'Marks' })
vim.keymap.set('n', '<leader>sq', function()
  ensure_setup(); Snacks.picker.qflist()
end, { desc = 'Quickfix List' })
vim.keymap.set('n', '<leader>sR', function()
  ensure_setup(); Snacks.picker.resume()
end, { desc = 'Resume' })
vim.keymap.set('n', '<leader>su', function()
  ensure_setup(); Snacks.picker.undo()
end, { desc = 'Undo History' })
-- lsp
vim.keymap.set('n', 'gd', function()
  ensure_setup(); Snacks.picker.lsp_definitions()
end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function()
  ensure_setup(); Snacks.picker.lsp_declarations()
end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function()
  ensure_setup(); Snacks.picker.lsp_references()
end, { nowait = true, desc = 'References' })
vim.keymap.set('n', 'gI', function()
  ensure_setup(); Snacks.picker.lsp_implementations()
end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'gy', function()
  ensure_setup(); Snacks.picker.lsp_type_definitions()
end, { desc = 'Goto T[y]pe Definition' })
vim.keymap.set('n', '<leader>ss', function()
  ensure_setup(); Snacks.picker.lsp_symbols()
end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function()
    ensure_setup(); Snacks.picker.lsp_workspace_symbols()
  end,
  { desc = 'LSP Workspace Symbols' })
-- buf handling
vim.keymap.set('n', '<leader>bq', function()
  ensure_setup(); Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bQ', function()
  ensure_setup(); Snacks.bufdelete({ force = true })
end, { desc = 'Delete Buffer (force)' })
