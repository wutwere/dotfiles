return {
	-- { "folke/tokyonight.nvim", opts = { transparent = true, styles = { floats = "transparent" } } },
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
				transparency = true,
			},

			highlight_groups = {
				["@markup.italic"] = { italic = true },
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
					-- component_separators = { left = "", right = "" },
					-- section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { { "buffers", use_mode_colors = true, max_length = vim.o.columns / 2 } },
					lualine_c = {},
					lualine_x = { --[["encoding", "fileformat", "filetype",]]
						"branch",
						"diff",
						"diagnostics",
						"progress",
					},
					lualine_y = {
						-- {
						-- 	require("noice").api.statusline.mode.get,
						-- 	cond = function()
						-- 		local noice_status = require("noice").api.statusline
						-- 		return noice_status.mode.has() and noice_status.mode.get():sub(1, 3) == "rec"
						-- 	end,
						-- 	color = { fg = "#ff9e64" },
						-- },
					},
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
