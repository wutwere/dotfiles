local KEYMAPS = require("config.keymaps")

return {
	{ "ThePrimeagen/vim-be-good" },
	{
		"echasnovski/mini.files",
		config = function()
			local mini_files = require("mini.files")
			mini_files.setup({
				windows = {
					max_number = 2,
					preview = true,
					width_preview = 55,
					width_nofocus = 30,
					width_focus = 30,
				},
			})
			KEYMAPS.mini_files()
		end,
	},
	{ "MagicDuck/grug-far.nvim", opts = { windowCreationCommand = "e" }, version = "1.6.3" },
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.tex" },
				callback = function()
					vim.opt_local.conceallevel = 2
				end,
			})
			vim.g.tex_conceal = "abdmg"
			vim.g.vimtex_view_method = "sioyek"
			vim.g.vimtex_callback_progpath = vim.fn.system("where nvim")
			vim.g.vimtex_quickfix_open_on_warning = 0
		end,
	},
	{ "lewis6991/gitsigns.nvim", opts = { current_line_blame_opts = { delay = 0 } } },
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		opts = { default_mappings = false },
		init = function()
			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				callback = function()
					vim.cmd("GitConflictRefresh")
				end,
			})
		end,
	},
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			KEYMAPS.multicursor(mc)
		end,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			legacy_computing_symbols_support = true,
			smear_between_neighbor_lines = false,
			cursor_color = "#ffffff",
		},
	},
}
