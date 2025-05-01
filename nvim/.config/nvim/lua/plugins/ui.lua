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
						theme.normal.c.bg = nil
						return theme
					end)(),
					always_show_tabline = false,
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { { "buffers", use_mode_colors = true, max_length = vim.o.columns / 2 } },
					lualine_c = {},
					lualine_x = {
						"branch",
						"diff",
						"diagnostics",
						"progress",
					},
					lualine_y = {},
					lualine_z = { "location" },
				},
				tabline = { lualine_a = { { "tabs", mode = 2, use_mode_colors = true, max_length = vim.o.columns } } },
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
