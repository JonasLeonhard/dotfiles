local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()

-- -------------------------------------- Core: General Appearance ---------------------------------------
config.font = wezterm.font 'IosevkaTerm Nerd Font'
config.font_size = 18
config.default_prog = { 'nu' }

config.color_scheme = "catppuccin-mocha"
config.colors = {
  background = '#0a0a0a',
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    background = '#0a0a0a',
    inactive_tab = {
      bg_color = '#191919',
      fg_color = "#ffffff"
    },

    -- Defines the appearance of the 'new tab' button (+)
    new_tab = {
      bg_color = '#191919',
      fg_color = "#ffffff"
    },
  },
}

config.window_frame = {
  font = wezterm.font { family = "IosevkaTerm Nerd Font" },
  font_size = 15.0,
}
config.window_decorations = "NONE"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 10000
config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on('update-status', function(window, pane)
  local workspace_name = window:active_workspace()
  window:set_left_status(wezterm.format({
    { Background = { Color = '#191919' } },
    { Foreground = { Color = '#ffffff' } },
    { Text = ' [' .. workspace_name .. '] ' },
  }))
end)

-- -------------------------------------- KEYBINDS ---------------------------------------
config.leader = { key = "a", mods = "CTRL" } -- enables mods = "LEADER"
config.keys = {
  {
    key = 't',
    mods = 'LEADER',
    action = act.ShowTabNavigator,
  },
  {
    key = 'r',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      -- Get all existing workspaces
      local workspaces = {}
      for _, workspace in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, {
          label = workspace,
          id = workspace,
        })
      end

      -- Add option to create new workspace
      table.insert(workspaces, {
        label = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Green' } },
          { Text = '+ Create New Workspace' },
        },
        id = '__CREATE_NEW__',
      })

      window:perform_action(
        wezterm.action.InputSelector {
          title = 'Select or Create Workspace',
          choices = workspaces,
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if id == '__CREATE_NEW__' then
              -- Prompt for new workspace name
              inner_window:perform_action(
                wezterm.action.PromptInputLine {
                  description = wezterm.format {
                    { Attribute = { Intensity = 'Bold' } },
                    { Foreground = { AnsiColor = 'Fuchsia' } },
                    { Text = 'Enter new workspace name' },
                  },
                  action = wezterm.action_callback(function(prompt_window, prompt_pane, line)
                    if line and line ~= '' then
                      prompt_window:perform_action(
                        wezterm.action.SwitchToWorkspace {
                          name = line,
                        },
                        prompt_pane
                      )
                    end
                  end),
                },
                inner_pane
              )
            elseif id then
              -- Switch to existing workspace
              inner_window:perform_action(
                wezterm.action.SwitchToWorkspace {
                  name = id,
                },
                inner_pane
              )
            end
          end),
        },
        pane
      )
    end),
  },
  {
    key = 'W',
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(act.PromptInputLine({
        description = "Rename workspace: ",
        action = wezterm.action_callback(function(_, _, line)
          if not line or line == "" then
            return
          end

          mux.rename_workspace(mux.get_active_workspace(), line)
        end),
      }), pane)
    end),
  },
  {
    key = "s",
    mods = "LEADER",
    action = act.SplitHorizontal({
      domain = "CurrentPaneDomain" })
  },
  {
    key = "v",
    mods = "LEADER",
    action = act.SplitVertical({
      domain = "CurrentPaneDomain" })
  },
  { key = "q",          mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "h",          mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j",          mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k",          mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l",          mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "m",          mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "LeftArrow",  mods = "LEADER", action = act.RotatePanes("CounterClockwise") },
  { key = "RightArrow", mods = "LEADER", action = act.RotatePanes("Clockwise") },
}

-- navigate to tab with LEADER-<NUMBER>
local index_offset = config.tab_and_split_indices_are_zero_based and 0 or 1
for i = index_offset, 9 do
  table.insert(config.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - index_offset) })
end

return config
