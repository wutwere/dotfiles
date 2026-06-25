local FLASH_INTERVAL = 80
local LUALINE_BG = "#1f242d"
local LOCATION_FLASH_BG = "#f85149"

local function refresh()
	require("lualine").refresh({ place = { "statusline" } })
end

local function flash(buf, win)
	if win == -1 or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).relative ~= "" then
		return
	end
	if vim.bo[buf].buftype ~= "" or vim.bo[buf].filetype == "oil" then
		return
	end

	local token = (vim.w[win]._lualine_flash_token or 0) + 1
	vim.w[win]._lualine_flash = true
	vim.w[win]._lualine_flash_token = token
	refresh()

	for i = 1, 3 do
		vim.defer_fn(function()
			if not vim.api.nvim_win_is_valid(win) or vim.w[win]._lualine_flash_token ~= token then
				return
			end
			vim.w[win]._lualine_flash = i % 2 == 0
			refresh()
		end, FLASH_INTERVAL * i)
	end
end

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function(_, opts)
			vim.api.nvim_create_autocmd("BufWinEnter", {
				callback = function(args)
					flash(args.buf, vim.fn.bufwinid(args.buf))
				end,
			})

			require("lualine").setup({
				options = {
					theme = (function()
						local theme = require("lualine.themes.iceberg")
						-- wtf does this do
						-- theme.inactive.a.gui = nil
						for _, mode in pairs(theme) do
							for k, section in pairs(mode) do
								-- if k == "a" then
								--  -- invert color
								-- 	section.fg = section.bg
								-- end
								if k == "c" then
									section.bg = LUALINE_BG -- background
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
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							path = 4,
							color = function()
								local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
								return {
									fg = "#ffffff",
									-- make it flash on buffer changes
									bg = vim.w[win]._lualine_flash and LOCATION_FLASH_BG or LUALINE_BG,
								}
							end,
						},
					},
					lualine_x = {
						"diagnostics",
						"lsp_status",
						"branch",
					},
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
}
