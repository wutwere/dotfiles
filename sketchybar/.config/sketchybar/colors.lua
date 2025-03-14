local cols = {
	transparent = 0x00000000,
}

local mine = {
	black = 0xff181926,
	white = 0xffcdd6f4,
	red = 0xffff229e,
	-- green = 0xffe4bebb, -- light rose pine peach
	-- green = 0xffbb9af7, -- purple
	green = 0xffbfa8e3,
	blue = 0xff7aa2f7,
	yellow = 0xffa6e3a1,
	orange = 0xfffab387,
	magenta = 0xffcba6f7,
	grey = 0xff939ab7,
	mauve = 0xff9cd399,
	bg1 = 0xa1000000,
	-- bg2 = 0xff64697d,
	bg2 = 0x00000000,
	transparent = 0x00000000,
}

local mine_clear_light = {
	white = 0xff181926,
	black = 0xffcdd6f4,
	red = 0xffff229e,
	green = 0xff40434d,
	blue = 0xff7aa2f7,
	yellow = 0xffa6e3a1,
	orange = 0xfffab387,
	magenta = 0xffcba6f7,
	grey = 0xff535a77,
	mauve = 0xff9cd399,
	bg1 = 0x66ffffff,
	-- bg2 = 0xff64697d,
	bg2 = 0x00000000,
	transparent = 0x00000000,
}

local catppuccin_mocha = {
	black = 0xff181926,
	white = 0xffcdd6f4,
	red = 0xff350586,
	green = 0xff9cd399,
	blue = 0xff0068c4,
	yellow = 0xffa6e3a1,
	orange = 0xfffab387,
	magenta = 0xffcba6f7,
	grey = 0xff939ab7,
	mauve = 0xff9cd399,
	bg1 = 0xff1f2335,
	bg2 = 0xff1b033b,
}

local monotone = {
	black = 0xffcdd6f4,
	white = 0xffcdd6f4,
	red = 0xffcdd6f4,
	green = 0xffcdd6f4,
	blue = 0xffcdd6f4,
	yellow = 0xffcdd6f4,
	orange = 0xffcdd6f4,
	magenta = 0xffcdd6f4,
	grey = 0xffcdd6f4,
	mauve = 0xffcdd6f4,
	bg1 = cols.transparent,
	bg2 = cols.transparent,
}

local gruvbox = {
	black = 0xff282828,
	white = 0xffebdbb2,
	red = 0xffcc241d,
	green = 0xff98971a,
	blue = 0xff458588,
	yellow = 0xffd79921,
	orange = 0xffd65d0e,
	magenta = 0xffb16286,
	grey = 0xffa89984,
	mauve = 0xffb16286,
	bg1 = 0xff3c3836,
	bg2 = 0xff504945,
}

local function with_alpha(color, alpha)
	if alpha > 1.0 or alpha < 0.0 then
		return color
	end
	return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

colors = mine
colors.with_alpha = with_alpha

colors.bar = {
	bg = colors.bg1,
	border = colors.black,
}
colors.popup = {
	bg = colors.bg1,
	border = colors.transparent,
}

return colors
