local colors = require("colors")
local icons = require("icons")

-- Padding item required because of bracket
-- sbar.add("item", { width = 5 })

local apple = sbar.add("item", {
	icon = {
		font = { size = 15.0 },
		string = icons.apple,
		padding_right = 10,
		padding_left = 10,
		color = colors.white,
	},
	label = { drawing = false },
	background = {
		color = colors.bg1,
		border_color = colors.bg2,
		-- border_width = 0
	},
	padding_left = 0,
	padding_right = -2,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
	background = {
		color = colors.transparent,
		height = 25,
		-- border_color = colors.grey,
	},
})

-- Padding item required because of bracket
sbar.add("item", { width = 7 })
