local CUSTOM_HIGHLIGHTS = {
	["@markup.italic"] = { italic = true }, -- for markdown if i decide to disable global italic
	["BlinkCmpDoc"] = { bg = "NONE" },
	["BlinkCmpDocSeparator"] = { bg = "NONE" },
	["BlinkCmpMenu"] = { bg = "NONE" },
	["BufferLineFill"] = { bg = "NONE" },
	["ColorColumn"] = { bg = "#0f0f1f" }, -- markdown code block
	["Comment"] = { italic = true }, -- for markdown if i decide to disable global italic
	["CursorLine"] = { bg = "NONE" },
	["Directory"] = { bg = "NONE" },
	["Pmenu"] = { bg = "NONE" }, -- for blink cmp
	["PmenuExtra"] = { bg = "NONE" }, -- for blink cmp
	["RenderMarkdownChecked"] = { fg = "#A7E22E" },
	["Search"] = { bg = "NONE" },
	["SignColumn"] = { bg = "NONE" },
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
		"loctvl842/monokai-pro.nvim",
		priority = 1000,
		opts = {
			transparent_background = true,
			background_clear = {
				"float_win",
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
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function(_, opts)
			require("lualine").setup({
				options = {
					theme = (function()
						local theme = require("lualine.themes.rose-pine-alt")
						theme.normal.a.fg = "#F92572"
						theme.inactive.a.gui = nil
						for _, mode in pairs(theme) do
							for k, section in pairs(mode) do
								-- if k == "a" then
								-- 	section.fg = section.bg
								-- end
								section.bg = "NONE" -- fully transparent background
							end
						end
						return theme
					end)(),
					always_show_tabline = true,
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {},
					lualine_c = {
						"branch",
						"diff",
						{ "tabs", mode = 1, use_mode_colors = true, max_length = vim.o.columns / 2 },
					},
					lualine_x = {
						function()
							local reg = vim.fn.reg_recording()
							return reg == "" and "" or "recording @" .. reg
						end,
						"searchcount",
						"diagnostics",
						"lsp_status",
						"progress",
					},
					lualine_y = {},
					lualine_z = { "location" },
				},
				tabline = {
					lualine_a = {
						{
							"buffers",
							mode = 0,
							show_filename_only = true,
							use_mode_colors = false,
							max_length = vim.o.columns,
						},
					},
				},
			})
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		opts = {},
		init = function()
			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				callback = function()
					vim.cmd("ColorizerAttachToBuffer")
				end,
			})
		end,
	},
}
