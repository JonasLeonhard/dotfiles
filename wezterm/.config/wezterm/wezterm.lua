local wezterm = require 'wezterm'

local config = {}

-- Core: General Appearance
config.font = wezterm.font 'ZedMono Nerd Font'
config.font_size = 18
config.default_prog = { '/opt/homebrew/bin/nu' }

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
  font = wezterm.font { family = "ZedMono Nerd Font" },
  font_size = 15.0,
}
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 10000

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
