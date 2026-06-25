-- Using WezTerm on Windows/WSL,
-- Ghostty on MacOS.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-------------
-- GENERAL --
-------------

config.enable_tab_bar = false
config.initial_cols = 120
config.initial_rows = 50
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.color_scheme = "Monokai Remastered"
config.colors = { background = "#000000" }
config.window_background_opacity = 1
config.max_fps = 255

config.wsl_domains = {
	{
		name = "WSL:archlinux",
		distribution = "archlinux",
	},
	{
		name = "WSL:NixOS",
		distribution = "NixOS",
	},
}

config.default_domain = "WSL:archlinux"

----------
-- FONT --
----------

config.font = wezterm.font("Monaspace Neon")
config.font_size = 14
config.line_height = 1
config.cell_width = 1

-----------------
-- KEYBINDINGS --
-----------------

local act = wezterm.action

config.keys = {
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString("\027\r"),
	},
}

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

addTmuxKey("t", "t")
addTmuxKey("w", "w")
addTmuxKey("s", "s")
addTmuxKey("f", "f")
addTmuxKey("b", "b")
addTmuxKey("[", "[")
addTmuxKey("u", "U")
addTmuxKey("d", "D")
addTmuxKey("/", "/")

return config
