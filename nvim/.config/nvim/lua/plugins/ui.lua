return {
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
				italic = true,
				transparency = true,
			},

			highlight_groups = {
				["@markup.italic"] = { italic = true }, -- for markdown if i decide to disable global italic
				["PmenuExtra"] = { bg = "NONE" }, -- for blink cmp
				["CursorLine"] = { bg = "NONE" },
			},
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
						for _, mode in pairs(theme) do
							for _, section in pairs(mode) do
								section.bg = nil -- fully transparent background
							end
						end
						return theme
					end)(),
					always_show_tabline = true,
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						"branch",
						"diff",
						{ "tabs", mode = 1, use_mode_colors = true, max_length = vim.o.columns / 2 },
					},
					lualine_c = {},
					lualine_x = {
						"diagnostics",
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
							show_filename_only = false,
							use_mode_colors = true,
							-- max_length = vim.o.columns,
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
