-- Using WezTerm on Windows/WSL,
-- Ghostty on MacOS.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_tab_bar = true
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.initial_cols = 120
config.initial_rows = 30
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
-- config.color_scheme = "tokyonight"
-- config.color_scheme = "catppuccin-macchiato"
config.color_scheme = "rose-pine"
config.font = wezterm.font("CaskaydiaMono Nerd Font Mono")
config.font_antialias = "Subpixel"
config.line_height = 1.3
config.max_fps = 144

config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 300
config.animation_fps = 60

local act = wezterm.action

config.keys = {}

local function addTmuxKey(want, tmux, mods)
	mods = mods or "ALT"
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

addTmuxKey("h", "h")
addTmuxKey("j", "j")
addTmuxKey("k", "k")
addTmuxKey("l", "l")
addTmuxKey("h", "H", "ALT|SHIFT")
addTmuxKey("j", "J", "ALT|SHIFT")
addTmuxKey("k", "K", "ALT|SHIFT")
addTmuxKey("l", "L", "ALT|SHIFT")
addTmuxKey("x", "x")

addTmuxKey("t", "c")
addTmuxKey("w", "&")
addTmuxKey("s", "s")
addTmuxKey("f", "f")
addTmuxKey("b", "b")

config.wsl_domains = {
	{
		name = "WSL:Arch",
		distribution = "Arch",
	},
}

--=== THIS IS FOR WSL ===--
config.default_domain = "WSL:Arch"

return config
