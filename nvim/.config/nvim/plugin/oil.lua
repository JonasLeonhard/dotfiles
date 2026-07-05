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

          if current_dir then
            -- fff.nvim has a built-in method for scoping to a specific directory
            require("fff").find_files_in_dir(current_dir)
          end
        end,
        mode = "n",
        nowait = true,
        desc = "Find files in the current (Oil) directory"
      },

      ["<leader>sg"] = {
        callback = function()
          local oil = require("oil")
          local current_dir = oil.get_current_dir()

          if current_dir then
            require("fff").live_grep({ cwd = current_dir })
          end
        end,
        mode = "n",
        nowait = true,
        desc = "ripgrep in the current (Oil) directory"
      },

      ["<leader>sd"] = {
        callback = function()
          local oil = require("oil")
          local current_dir = oil.get_current_dir()

          if not current_dir then return end

          -- Use fd to grab directories relative to Oil's current directory
          local dirs = vim.fn.systemlist({
            'fd', '--type', 'd', '-I', '--hidden', '--exclude', '.git', '.', current_dir
          })

          if vim.v.shell_error ~= 0 or #dirs == 0 then
            vim.notify("No directories found or fd is not installed.", vim.log.levels.WARN)
            return
          end

          vim.ui.select(dirs, {
            prompt = 'Search Directories (Oil) ',
            format_item = function(item)
              -- Strip the base Oil directory from the path so the menu shows clean, relative paths
              local relative_path = item:gsub("^" .. vim.pesc(current_dir), "")
              return relative_path
            end,
          }, function(choice)
            if choice then
              -- `choice` is the full absolute path from fd, so we can just open it directly
              vim.schedule(function()
                require("oil").open(choice)
              end)
            end
          end)
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
  local cwd = vim.fn.getcwd()

  -- Use fd to grab directories silently via systemlist
  local dirs = vim.fn.systemlist({
    'fd', '--type', 'd', '-I', '--hidden', '--exclude', '.git', '.', cwd
  })

  if vim.v.shell_error ~= 0 or #dirs == 0 then
    vim.notify("No directories found or fd is not installed.", vim.log.levels.WARN)
    return
  end

  -- Feed the results into Neovim's native UI select
  vim.ui.select(dirs, {
    prompt = 'Search Directories  ',
    format_item = function(item)
      -- Make the paths relative and cleaner to read
      return vim.fn.fnamemodify(item, ':.')
    end,
  }, function(choice)
    -- This callback triggers when you hit Enter on a selection
    if choice then
      vim.schedule(function() open_oil(choice) end)
    end
  end)
end, { desc = 'Search Directories' })
