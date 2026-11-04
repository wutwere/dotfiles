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
config.color_schemes = {
	["Forge Ember"] = {
		foreground = "#f4e2c8",
		background = "#140c07",
		cursor_bg = "#ff6a1f",
		cursor_border = "#ff6a1f",
		cursor_fg = "#140c07",
		selection_bg = "#33220f",
		selection_fg = "#544c47",
		ansi = { "#241810", "#ff4733", "#c4c24a", "#ffb347", "#f0a24f", "#ff6a4d", "#ffd27a", "#e6d2b6" },
		brights = { "#7a6248", "#ff4733", "#c4c24a", "#ff7a2d", "#f0a24f", "#ff6a4d", "#ffd27a", "#f4e2c8" },
	},
	["Cathode Amber"] = {
		foreground = "#f0c88a",
		background = "#140f08",
		cursor_bg = "#ffb642",
		cursor_border = "#ffb642",
		cursor_fg = "#140f08",
		selection_bg = "#4a3212",
		selection_fg = "#ffe8c2",
		ansi = { "#241a0e", "#e8763f", "#b8a83f", "#ffb642", "#c98d4f", "#cf8a62", "#d4a852", "#cfa972" },
		brights = { "#7a6238", "#f2925f", "#d0c05e", "#ffcc70", "#dca86e", "#e2a67f", "#e7c077", "#ffe8c2" },
	},
}
config.color_scheme = "Forge Ember"
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

config.font = wezterm.font("GeistMono Nerd Font")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font_size = 11
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
		action = wezterm.action.SendString("\027[13;2u"),
	},
}

local function addTmuxKey(want, tmux, mods)
	mods = mods or "ALT"
	local prefix = "b" -- herdr
	-- herdr overrides
	if want ~= "f" then
		if want == "t" then
			tmux = "c"
		elseif want == "w" then
			tmux = "x"
		elseif tmux == "L" or tmux == "H" then
			tmux = "v"
		elseif tmux == "J" or tmux == "K" then
			tmux = "-"
		end
		table.insert(config.keys, {
			key = want,
			mods = mods,
			action = act.Multiple({
				act.SendKey({ key = prefix, mods = "CTRL" }),
				act.SendKey({ key = tmux }),
			}),
		})
	else
		table.insert(config.keys, {
			key = want,
			mods = mods,
			action = act.Multiple({
				act.SendKey({ key = prefix, mods = "CTRL" }),
				act.SendKey({ key = "[" }),
				act.SendKey({ key = "?" }),
			}),
		})
	end
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
