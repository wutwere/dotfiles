return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function(_, opts)
			require("lualine").setup({
				options = {
					theme = (function()
						local theme = require("lualine.themes.ayu_mirage")
						-- wtf does this do
						-- theme.inactive.a.gui = nil
						for _, mode in pairs(theme) do
							for k, section in pairs(mode) do
								-- if k == "a" then
								--  -- invert color
								-- 	section.fg = section.bg
								-- end
								if k == "c" then
									section.bg = "NONE" -- fully transparent background
								end
							end
						end
						return theme
					end)(),
					always_show_tabline = true,
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						function()
							local current_line = vim.fn.line(".")
							return current_line .. "/" .. vim.fn.line("$")
						end,
					},
					lualine_c = {
						{ "filename", path = 4 },
						"diagnostics",
					},
					lualine_x = {
						-- function()
						-- 	local reg = vim.fn.reg_recording()
						-- 	return reg == "" and "" or "recording @" .. reg
						-- end,
						-- "searchcount",
						"lsp_status",
						-- "progress",
					},
					lualine_y = {
						"diff",
					},
					lualine_z = {
						-- "location",
						"branch",
					},
				},
				-- tabline = {
				-- 	lualine_a = {
				-- 		{
				-- 			"buffers",
				-- 			mode = 2,
				-- 			show_filename_only = true,
				-- 			use_mode_colors = false,
				-- 			max_length = vim.o.columns,
				-- 		},
				-- 	},
				-- },
			})
		end,
	},
}
