local KEYMAPS = require("config.keymaps")

return {
	{
		"echasnovski/mini.files",
		config = function()
			local mini_files = require("mini.files")
			mini_files.setup({
				windows = {
					max_number = 2,
					preview = true,
					width_preview = 30,
					width_nofocus = 50,
					width_focus = 50,
				},
				options = {
					permanent_delete = false,
				},
			})
			KEYMAPS.mini_files()
		end,
	},
	-- {
	-- 	"stevearc/oil.nvim",
	-- 	---@module 'oil'
	-- 	---@type oil.SetupOpts
	-- 	opts = {
	-- 		default_file_explorer = true,
	-- 		columns = {
	-- 			"icon",
	-- 		},
	-- 		delete_to_trash = true,
	-- 		view_options = {
	-- 			show_hidden = true,
	-- 		},
	-- 		win_options = {
	-- 			winbar = "%!v:lua.get_oil_winbar()",
	-- 		},
	-- 	},
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	init = function()
	-- 		function _G.get_oil_winbar()
	-- 			local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	-- 			local dir = require("oil").get_current_dir(bufnr)
	-- 			if dir then
	-- 				return vim.fn.fnamemodify(dir, ":~")
	-- 			else
	-- 				-- If there is no current directory (e.g. over ssh), just show the buffer name
	-- 				return vim.api.nvim_buf_get_name(0)
	-- 			end
	-- 		end
	-- 		KEYMAPS.oil()
	-- 	end,
	-- },
	{
		"FylerOrg/fyler.nvim",
		opts = {
			-- kind = "split_left_most",
			-- Configure the width of that window kind.
			kind_presets = {
				split_left_most = {
					width = 35,
				},
			},
			win_opts = {
				nu = true,
				rnu = true,
				scl = "no",
			},
			extensions = {
				-- Enable git extension
				-- git = { enabled = true }
				-- Enable git extension with right aligned icons
				git = { enabled = true, inline = false },
				-- Enable trash extension
				trash = { enabled = true },
				-- Enable watcher extension
				watcher = { enabled = true },
			},
			integrations = {
				-- Use mini.icons as the icon provider
				icon = "nvim_web_devicons",
			},
			ui = {
				-- indent_guides = true,
				hidden_items = {
					switches = {},
				},
			},
			mappings = {
				n = {
					["<CR>"] = {
						action = "select",
						args = {
							pick = false,
							close = false,
						},
						desc = "Open file in editing window",
					},
				},
			},
		},
	},
}
