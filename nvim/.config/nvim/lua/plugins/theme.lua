local CUSTOM_HIGHLIGHTS = {
	["@markup.italic"] = { italic = true }, -- for markdown if i decide to disable global italic
	["BlinkCmpDoc"] = { bg = "NONE" },
	["BlinkCmpDocSeparator"] = { bg = "NONE" },
	["BlinkCmpMenu"] = { bg = "NONE" },
	["BufferLineFill"] = { bg = "NONE" },
	["ColorColumn"] = { bg = "#181C29" }, -- markdown code block
	["Comment"] = { italic = true }, -- for markdown if i decide to disable global italic
	-- ["CursorLine"] = { bg = "NONE" },
	["Directory"] = { bg = "NONE" },
	["LazyNormal"] = { bg = "NONE" },
	["Pmenu"] = { bg = "NONE" }, -- for blink cmp
	["PmenuExtra"] = { bg = "NONE" }, -- for blink cmp
	["RenderMarkdownChecked"] = { fg = "#A7E22E" },
	["SignColumn"] = { bg = "NONE" },
	["SnippetTabstop"] = { link = "NONE" },
	["SpellBad"] = { link = "NONE" },
	["SpellCap"] = { link = "NONE" },
	["SpellLocal"] = { link = "NONE" },
	["SpellRare"] = { link = "NONE" },
	["StatusLine"] = { bg = "NONE" },
	["TabLineFill"] = { bg = "NONE" },
	["TreesitterContext"] = { bg = "NONE" },
	["TreesitterContextLineNumber"] = { link = "Keyword" },
}

return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {
			contrast = "hard",
			transparent_mode = true,
			terminal_colors = true,
			overrides = CUSTOM_HIGHLIGHTS,
		},
	},
	{
		"loctvl842/monokai-pro.nvim",
		priority = 1000,
		opts = {
			transparent_background = true,
			background_clear = {
				"float_win",
				"which-key",
			},
			styles = {
				keyword = { italic = false }, -- any other keyword
				type = { italic = false }, -- (preferred) int, long, char, etc
				storageclass = { italic = false }, -- static, register, volatile, etc
				structure = { italic = false }, -- struct, union, enum, etc
				parameter = { italic = false }, -- parameter pass in function
				annotation = { italic = false },
				tag_attribute = { italic = false },
			},
			override = function(c)
				return CUSTOM_HIGHLIGHTS
			end,
		},
	},
	-- {
	-- 	"projekt0n/github-nvim-theme",
	-- 	name = "github-theme",
	-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	opts = {
	-- 		options = {
	-- 			transparent = true,
	-- 			styles = {
	-- 				comments = "italic",
	-- 				keywords = "bold",
	-- 				types = "italic,bold",
	-- 			},
	-- 		},
	-- 		groups = {
	-- 			all = CUSTOM_HIGHLIGHTS,
	-- 		},
	-- 	},
	-- },
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		opts = {
			variant = "auto", -- auto, main, moon, or dawn
			dark_variant = "main", -- main, moon, or dawn
			dim_inactive_windows = false,
			extend_background_behind_borders = true,

			styles = {
				bold = true,
				italic = false,
				transparency = false,
			},

			highlight_groups = CUSTOM_HIGHLIGHTS,
		},
	},
}
