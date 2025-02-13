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
-- config.window_close_confirmation = "NeverPrompt"
config.window_padding = { left = 5, right = 5, top = 10, bottom = 0 }
config.initial_cols = 170
config.initial_rows = 45
config.window_background_opacity = 0.9
config.macos_window_background_blur = 15
config.color_scheme = "Tokyo Night"

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

local function battery_remaining()
	local battery = wezterm.battery_info()[1]
	local sec = battery.time_to_empty
	if sec then
		local battery_min = math.min(math.ceil(sec / 60), 1200)
		local battery_hr = math.floor(battery_min / 60)
		return string.format(
			" 󰂂 %d%% (%dh %02dm) ",
			math.floor(battery.state_of_charge * 100),
			tostring(battery_hr),
			battery_min % 60
		)
	end
	return " 󰂋  "
end

local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
local transparent = config.colors.tab_bar.background
local active_background = "#7aa2f7"
local active_foreground = "#1a1b27"
local inactive_background = "#1a1b27"
local inactive_foreground = "#7aa2f7"

local function getTabTitle(tab_info)
	local processName = tab_info.active_pane.foreground_process_name
	return string.gsub(processName, "(.*[/\\])(.*)", "%2")
end

-- this code is so bad HOLY...............
local function format_tab_title(tab, tabs, panes, config, hover, max_width)
	local title = getTabTitle(tab)
	local index = tab.tab_index + 1
	local isFirst = index == 1
	local isLast = index == #tabs and #tabs ~= 0
	title = wezterm.truncate_right(title, max_width - 2)

	local items = {}

	if tab.is_active then
		table.insert(items, { Background = { Color = active_background } })
		table.insert(items, { Foreground = { Color = active_foreground } })
		table.insert(items, { Text = " " .. index .. "  " .. title .. " " })

		if isFirst then
			if #tabs > 1 then
				table.insert(items, { Background = { Color = inactive_background } })
				table.insert(items, { Foreground = { Color = active_background } })
			else
				table.insert(items, { Background = { Color = transparent } })
				table.insert(items, { Foreground = { Color = active_background } })
			end
		end

		if isLast then
			table.insert(items, { Background = { Color = transparent } })
			table.insert(items, { Foreground = { Color = active_background } })
		else
			table.insert(items, { Background = { Color = inactive_background } })
			table.insert(items, { Foreground = { Color = active_background } })
		end

		table.insert(items, { Text = SOLID_RIGHT_ARROW })
	else
		table.insert(items, { Background = { Color = active_background } })
		table.insert(items, { Foreground = { Color = active_foreground } })
		table.insert(items, { Background = { Color = inactive_background } })
		table.insert(items, { Foreground = { Color = inactive_foreground } })
		table.insert(items, { Text = " " .. index .. "  " .. title .. " " })

		if isLast then
			table.insert(items, { Background = { Color = transparent } })
			table.insert(items, { Foreground = { Color = inactive_background } })
		else
			if index - 1 < #tabs then
				local nextTab = tabs[index + 1]
				if nextTab.is_active then
					table.insert(items, { Background = { Color = active_background } })
					table.insert(items, { Foreground = { Color = inactive_background } })
				else
					table.insert(items, { Background = { Color = inactive_background } })
					table.insert(items, { Foreground = { Color = inactive_background } })
				end
			end
		end
		table.insert(items, { Text = SOLID_RIGHT_ARROW })
	end

	return items
end
wezterm.on("format-tab-title", format_tab_title)

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		theme_overrides = {
			normal_mode = {
				x = { fg = inactive_foreground, bg = transparent },
				y = { fg = inactive_foreground, bg = inactive_background },
				z = { fg = active_foreground, bg = active_background },
			},
		},
	},
	sections = {
		tabline_a = {},
		tabline_b = {},
		tabline_c = {},
		tabline_y = {
			battery_remaining,
			{ "datetime", style = "%Y/%m/%d %H:%M:%S" },
		},
		tabline_z = {
			"domain",
			"workspace",
		},
	},
})

return config
