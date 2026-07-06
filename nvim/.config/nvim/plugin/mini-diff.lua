vim.pack.add({
  {
    src = 'https://github.com/nvim-mini/mini.diff',
  }
})
vim.schedule(function()
  require('mini.diff').setup({
    style = 'number',
    mappings = {
      apply = '',
      -- Reset hunks inside a visual/operator region
      reset = 'gr',
    },
    delay = {
      -- How much to wait before update following every text change
      text_change = 500,
    },
  })

  vim.keymap.set('n', '<leader>gH', function()
    MiniDiff.toggle_overlay()
  end, { desc = 'mini.diff - Toggle Inline Hunk Preview' })

  local function preview_hunk_range_split()
    local buf_data = require('mini.diff').get_buf_data(0)
    if not (buf_data and buf_data.hunks) then
      vim.notify("No diff data available for this buffer.", vim.log.levels.WARN, { title = "Hunk Preview" })
      return
    end

    local hunks = buf_data.hunks
    local ref_lines = vim.split(buf_data.ref_text or "", "\n")

    -- Find the hunk the cursor is in
    local cursor = vim.api.nvim_win_get_cursor(0)[1]
    local cur_idx
    for i, h in ipairs(hunks) do
      local match_start = h.buf_start == 0 and 1 or h.buf_start
      local match_end = h.buf_count == 0 and match_start or (match_start + h.buf_count - 1)

      if cursor >= match_start and cursor <= match_end then
        cur_idx = i
        break
      end
    end

    if not cur_idx then
      vim.notify("No hunk found at current line.", vim.log.levels.INFO, { title = "Hunk Preview" })
      return
    end

    -- Expand to nearby hunks (merge if separated by this many unchanged lines or fewer)
    local max_gap = 2
    local first_idx, last_idx = cur_idx, cur_idx

    while first_idx > 1 do
      local prev, curr = hunks[first_idx - 1], hunks[first_idx]
      local gap = curr.buf_start - (prev.buf_start + prev.buf_count)
      if gap > max_gap then break end
      first_idx = first_idx - 1
    end

    while last_idx < #hunks do
      local curr, next = hunks[last_idx], hunks[last_idx + 1]
      local gap = next.buf_start - (curr.buf_start + curr.buf_count)
      if gap > max_gap then break end
      last_idx = last_idx + 1
    end

    -- Calculate reference (Before) and buffer (After) boundaries
    local first_h = hunks[first_idx]
    local last_h = hunks[last_idx]

    local old_start = first_h.ref_start
    local old_end = last_h.ref_start + math.max(0, last_h.ref_count - 1)

    local new_start = first_h.buf_start == 0 and 1 or first_h.buf_start
    local new_end = last_h.buf_start + math.max(0, last_h.buf_count - 1)
    if last_h.buf_count == 0 and new_end < new_start then new_end = new_start end

    local function fmt_range(start_line, end_line)
      return (start_line == end_line) and tostring(start_line) or string.format("%d-%d", start_line, end_line)
    end

    -- Collect continuous block of old lines from the reference file
    local old = {}
    if old_start <= old_end then
      old = vim.list_slice(ref_lines, old_start, old_end)
    end

    if #old == 0 then
      vim.notify("Hunk block contains only additions. Nothing to preview.", vim.log.levels.INFO,
        { title = "Hunk Preview" })
      return
    end

    -- Create buffer and set lines
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, old)

    -- Set buffer options
    vim.api.nvim_set_option_value("filetype", vim.bo.filetype, { buf = buf })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

    -- Open a vertical split and assign the buffer to it
    vim.cmd("vsplit")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)

    -- Set a window bar to act as a sticky header, showing the change in lines
    local winbar_text = string.format("%%#Title#  Hunk Before [Lines: %s -> %s] ", fmt_range(old_start, old_end),
      fmt_range(new_start, new_end))
    vim.api.nvim_set_option_value("winbar", winbar_text, { win = win })

    -- Use a unique name by appending the buffer ID
    pcall(vim.api.nvim_buf_set_name, buf, "Hunk Before [" .. buf .. "]")

    -- Close mapping
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
  end

  vim.keymap.set({ "n", "v" }, "<leader>gh", preview_hunk_range_split, { desc = "Preview hunk range (split)" })
end)
