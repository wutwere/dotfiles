local DIRECTIONS = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_tab_bar = true
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
-- config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE | MACOS_FORCE_ENABLE_SHADOW"
-- config.window_decorations = "RESIZE"
-- config.window_close_confirmation = "NeverPrompt"
-- config.window_padding = { left = 0, right = 0, top = 10, bottom = 0 }
config.initial_cols = 170
config.initial_rows = 45
config.color_scheme = "tokyonight"

config.colors = {
	tab_bar = {
		background = not config.tab_bar_at_bottom and "rgba(26,27,38,0.9)" or "rgba(0,0,0,0)",
	},
}

config.inactive_pane_hsb = {
	saturation = 1,
	brightness = 1,
}

config.keys = {
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "r",
		mods = "ALT",
		action = wezterm.action.RotatePanes("CounterClockwise"),
	},
	{
		key = " ",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			local overrides = window:get_config_overrides()
				or {
					window_background_opacity = 1,
					macos_window_background_blur = 0,
				}
			if overrides.window_background_opacity == 1 then
				overrides.window_background_opacity = 0.90
				overrides.macos_window_background_blur = 50
			else
				overrides.window_background_opacity = 1
				overrides.macos_window_background_blur = 0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

for key, direction in pairs(DIRECTIONS) do
	table.insert(config.keys, {
		key = key,
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection(direction),
	})
	table.insert(config.keys, {
		key = key,
		mods = "SHIFT|ALT",
		action = wezterm.action.SplitPane({ direction = direction }),
	})
	table.insert(config.keys, {
		key = key,
		mods = "SUPER|ALT",
		action = wezterm.action.AdjustPaneSize({ direction, 5 }),
	})
end

local battery_to_icon = {
	quarter = wezterm.nerdfonts.fa_battery_quarter,
	half = wezterm.nerdfonts.fa_battery_half,
	three_quarters = wezterm.nerdfonts.fa_battery_three_quarters,
	full = wezterm.nerdfonts.fa_battery_full,
}

local function battery_remaining()
	local battery = wezterm.battery_info()[1]
	local sec = battery.time_to_empty
	local percent = math.floor(battery.state_of_charge * 100 + 0.5)
	local icon = battery_to_icon.full
	if battery.state_of_charge <= 0.375 then
		icon = battery_to_icon.quarter
	elseif battery.state_of_charge <= 0.625 then
		icon = battery_to_icon.half
	elseif battery.state_of_charge <= 0.875 then
		icon = battery_to_icon.three_quarters
	end
	if sec then
		local battery_min = math.min(math.floor(sec / 60 + 0.5), 1800)
		local battery_hr = math.floor(battery_min / 60)
		return string.format(" %s %d%% (%dh %02dm) ", icon, percent, tostring(battery_hr), battery_min % 60)
	end
	return string.format(" 󰂋 %d%% ", percent)
end

local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
local transparent = config.colors.tab_bar.background
local active_background = "#7aa2f7"
local active_foreground = "#1a1b27"
local inactive_background = "#1a1b27"
local inactive_foreground = "#565f89"
local dark_neutral = "#565f89"

local function getTabTitle(tab_info)
	local processName = tab_info.active_pane.foreground_process_name
	return string.gsub(processName, "(.*[/\\])(.*)", "%2")
end

local function format_tab_title(tab, tabs, panes, config, hover, max_width)
	local title = getTabTitle(tab)
	local index = tab.tab_index + 1
	local isLast = index == #tabs and #tabs ~= 0
	title = wezterm.truncate_right(title, max_width - 2)

	local items = {}

	local this_fg, this_bg, next_bg = inactive_foreground, inactive_background, transparent

	if tab.is_active then
		this_fg = active_foreground
		this_bg = active_background
	end

	if not isLast then
		if tabs[index + 1].is_active then
			next_bg = active_background
		else
			next_bg = inactive_background
		end
	end

	table.insert(items, { Background = { Color = this_bg } })
	table.insert(items, { Foreground = { Color = this_fg } })
	table.insert(items, { Text = " " .. index .. "  " .. title .. " " })
	table.insert(items, { Background = { Color = next_bg } })
	table.insert(items, { Foreground = { Color = this_bg } })
	table.insert(items, { Text = SOLID_RIGHT_ARROW })

	return items
end
wezterm.on("format-tab-title", format_tab_title)

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		theme_overrides = {
			normal_mode = {
				x = { fg = dark_neutral, bg = transparent },
				y = { fg = dark_neutral, bg = inactive_background },
				z = { fg = active_foreground, bg = active_background },
			},
		},
	},
	sections = {
		tabline_a = {},
		tabline_b = {},
		tabline_c = {},
		tabline_x = {
			"domain",
			"workspace",
			"ram",
			"cpu",
			battery_remaining,
			{ "datetime", style = "%H:%M:%S %m/%d/%Y" },
		},
		tabline_y = {},
		tabline_z = {},
	},
})

return config
