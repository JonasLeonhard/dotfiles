vim.pack.add({
  {
    src = 'https://github.com/stevearc/oil.nvim',
  }
})

local oil_window_to_buffer_map = {} -- maps a window id to a buffer id [window_id] = buffer_id, we use this to return to buffers later after opening oil (eg. toggle_oil)
local detail = false                -- show extra filedata toggle

local open_oil = function(open_opts)
  local current_buf = vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = current_buf })

  -- Prevent opening Oil in special buffers (like messages, terminal, quickfix)
  if buftype == "nofile" or buftype == "prompt" or buftype == "quickfix" or buftype == "terminal" then
    vim.notify("Cannot open Oil in '" .. buftype .. "' Buffers", vim.log.levels.WARN)
    return
  end

  -- save where the buffer we came from for the current window to return to later
  local current_buf_filetype = vim.api.nvim_get_option_value("filetype", { buf = current_buf })
  if current_buf_filetype ~= "oil" then
    local current_win = vim.api.nvim_get_current_win()

    oil_window_to_buffer_map[current_win] = {
      original_buf = current_buf
    }
  end

  local bufname = vim.fn.expand('%:t')
  require("oil").open(open_opts, nil, function()
    -- select the current buffer(filename) we came from, but dont throw an error if we cant find it
    pcall(vim.cmd, '/' .. bufname .. '$')
  end)
end

local toggle_oil = function(open_opts)
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_buf_filetype = vim.api.nvim_get_option_value("filetype", { buf = current_buf })

  if current_buf_filetype == "oil" then
    -- We're in an oil buffer, close it and return to original buffer
    local state = oil_window_to_buffer_map[current_win]
    if state and state.original_buf and vim.api.nvim_buf_is_valid(state.original_buf) then
      vim.api.nvim_set_current_buf(state.original_buf)
    end
    -- Clear state for this window
    oil_window_to_buffer_map[current_win] = nil
  else
    -- We're in a regular buffer, open oil and remember it
    open_oil(open_opts)
  end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(args)
    local win_id = tonumber(args.match)
    if win_id and oil_window_to_buffer_map[win_id] then
      oil_window_to_buffer_map[win_id] = nil
    end
  end,
})

local has_setup = false
local ensure_setup = function()
  if (has_setup) then return end

  require("oil").setup({
    cleanup_delay_ms = 0,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
    keymaps = {
      ["<CR>"] = {
        callback = function()
          require("oil").select(nil)
        end,
        desc = "Open file and maximize window",
      },
      ["<leader>sf"] = {
        callback = function()
          local oil = require("oil")
          local current_dir = oil.get_current_dir()

          Snacks.picker.files({
            cwd = current_dir,
          })
        end,
        mode = "n",
        nowait = true,
        desc = "Find files in the current (Oil) directory"
      },
      ["<leader>sg"] = {
        callback = function()
          local oil = require("oil")
          local current_dir = oil.get_current_dir()

          Snacks.picker.grep({
            cwd = current_dir,
          })
        end,
        mode = "n",
        nowait = true,
        desc = "ripgrep in the current (Oil) directory"
      },
      ["<leader>sd"] = {
        callback = function()
          local oil = require("oil")
          local current_dir = oil.get_current_dir()
          local opened_from_win = vim.api.nvim_get_current_win()

          Snacks.picker.pick({
            title = "Search Directories",
            cwd = current_dir,

            finder = function(opts, ctx)
              local proc_opts = {
                cmd = "fd",
                args = {
                  "--type", "d",
                  "-I",
                  "--hidden",
                  "--exclude", ".git",
                },
                cwd = opts.cwd,
              }
              return require("snacks.picker.source.proc").proc(proc_opts, ctx)
            end,
            format = "text",

            -- Configure action to open the selected directory in Oil
            confirm = function(picker, item)
              if item then
                picker:close()
                if vim.api.nvim_win_is_valid(opened_from_win) then
                  vim.api.nvim_set_current_win(opened_from_win)
                end
                vim.schedule(function()
                  open_oil(current_dir .. item.text)
                end)
              end
            end,

            -- Enable preview with tree if available
            preview = function(ctx)
              local item = ctx.item
              if not item or not item.text then return false end

              local tree_output = vim.fn.system({ "tree", item.text, "-L", "3" })
              vim.bo[ctx.buf].modifiable = true
              vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, vim.split(tree_output, "\n"))
              return true
            end,
          })
        end,
        mode = "n",
        nowait = true,
        desc = "Find subdirectories in the current (Oil) directory"
      },
      ["g$"] = {
        callback = function()
          local oil = require("oil")
          local current_dir = oil.get_current_dir()
          vim.cmd("botright split | lcd " .. current_dir .. " | terminal")
        end,
        mode = "n",
        nowait = true,
        desc = "Terminal in (Oil) directory"
      },
      ["gd"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
    },
  })
end

vim.schedule(function()
  ensure_setup()
end)

vim.keymap.set('n', '<leader>e', function()
  ensure_setup()
  toggle_oil(vim.fn.expand('%:p:h'))
end, { desc = 'Oil' })

vim.keymap.set('n', '<leader>E', function()
  ensure_setup()
  toggle_oil(vim.fn.getcwd())
end, { desc = 'Oil (cwd)' })

vim.keymap.set('n', '<leader>sd', function()
  ensure_setup()
  Snacks.picker.pick({
    title = 'Search Directories',
    cwd = vim.fn.getcwd(),
    finder = function(opts, ctx)
      return require('snacks.picker.source.proc').proc({
        cmd = 'fd',
        args = { '--type', 'd', '-I', '--hidden', '--exclude', '.git' },
        cwd = opts.cwd,
      }, ctx)
    end,
    format = 'text',
    confirm = function(picker, item)
      if item then
        picker:close()
        vim.schedule(function() open_oil(item.text) end)
      end
    end,
    preview = function(ctx)
      local item = ctx.item
      if not item or not item.text then return false end
      local tree_output = vim.fn.system({ 'tree', item.text, '-L', '3' })
      vim.bo[ctx.buf].modifiable = true
      vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, vim.split(tree_output, '\n'))
      return true
    end,
  })
end, { desc = 'Search Directories' })
