local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE | MACOS_FORCE_ENABLE_SHADOW"
-- config.window_close_confirmation = "NeverPrompt"
-- config.window_padding = { left = 0, right = 0, top = 10, bottom = 0, }
config.initial_cols = 100
config.initial_rows = 30
config.window_background_opacity = 0.96
config.macos_window_background_blur = 25
config.color_scheme = "Tokyo Night"

return config
