-- Using WezTerm on Windows/WSL,
-- Ghostty on MacOS.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-------------
-- GENERAL --
-------------

config.enable_tab_bar = false
-- config.window_decorations = "RESIZE"
config.initial_cols = 120
config.initial_rows = 30
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
-- config.color_scheme = "tokyonight"
-- config.color_scheme = "catppuccin-macchiato"
config.color_scheme = "Monokai Remastered"
config.colors = { background = "#0b0b12" }
config.window_background_opacity = 1.0
config.max_fps = 255
config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 300
config.animation_fps = 60

config.wsl_domains = {
	{
		name = "WSL:Arch",
		distribution = "Arch",
	},
}

config.default_domain = "WSL:Arch"

----------
-- FONT --
----------

config.freetype_load_target = "HorizontalLcd"
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "DemiBold" })
-- config.font_size = 11
-- config.line_height = 1.13
-- config.font = wezterm.font("Monaspace Argon")
-- config.harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }
-- config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.font_size = 9
config.line_height = 1.22
config.cell_width = 0.95
config.font_rules = {
	{
		intensity = "Normal",
		italic = true,
		font = wezterm.font("Monaspace Radon", { weight = "Regular" }),
	},
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font("Monaspace Neon", { weight = "ExtraBold" }),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font("Monaspace Radon", { weight = "ExtraBold" }),
	},
}

-----------------
-- KEYBINDINGS --
-----------------

local act = wezterm.action

config.keys = {
	{
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

local function addTmuxKey(want, tmux, mods)
	mods = mods or "CTRL"
	table.insert(config.keys, {
		key = want,
		mods = mods,
		action = act.Multiple({
			act.SendKey({ key = "Space", mods = "CTRL" }),
			act.SendKey({ key = tmux }),
		}),
	})
end

for i = 1, 9 do
	addTmuxKey(tostring(i), tostring(i))
end

-- addTmuxKey("h", "h")
-- addTmuxKey("j", "j")
-- addTmuxKey("k", "k")
-- addTmuxKey("l", "l")
addTmuxKey("h", "H", "CTRL|SHIFT")
addTmuxKey("j", "J", "CTRL|SHIFT")
addTmuxKey("k", "K", "CTRL|SHIFT")
addTmuxKey("l", "L", "CTRL|SHIFT")
addTmuxKey("x", "x")

addTmuxKey("t", "t")
addTmuxKey("w", "w", "CTRL|SHIFT")
addTmuxKey("s", "s")
addTmuxKey("f", "f")
addTmuxKey("b", "b")
addTmuxKey("[", "[")

return config
