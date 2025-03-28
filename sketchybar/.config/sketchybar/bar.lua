local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = false,
	height = 38,
	position = "top",
	-- color = colors.with_alpha(colors.bar.bg, 0.5),
	-- color = colors.bar.bg,
	color = colors.with_alpha(colors.bar.bg, 0),
	padding_right = 0,
	padding_left = 3,
	corner_radius = 5,
	margin = 8,
	y_offset = 0,
	-- border_width = 2,
	-- border_color = colors.bar.border
})
