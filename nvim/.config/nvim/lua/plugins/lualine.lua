return {
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
						{ "tabs", path = 1, mode = 1, use_mode_colors = true, max_length = vim.o.columns / 2 },
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
					lualine_z = {
						-- "location",
						function()
							return vim.fn.line("$") .. "L"
						end,
					},
				},
				tabline = {
					lualine_a = {
						{
							"buffers",
							mode = 2,
							show_filename_only = true,
							use_mode_colors = false,
							max_length = vim.o.columns,
						},
					},
				},
			})
		end,
	},
}
