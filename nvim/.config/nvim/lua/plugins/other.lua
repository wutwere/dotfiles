local KEYMAPS = require("config.keymaps")

return {
	{ "ThePrimeagen/vim-be-good" },
	-- {
	-- 	"lervag/vimtex",
	-- 	lazy = false,
	-- 	init = function()
	-- 		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	-- 			pattern = { "*.tex" },
	-- 			callback = function()
	-- 				vim.opt_local.conceallevel = 2
	-- 			end,
	-- 		})
	-- 		vim.g.tex_conceal = "abdmg"
	-- 		vim.g.vimtex_view_method = "sioyek"
	-- 		vim.g.vimtex_callback_progpath = vim.fn.system("where nvim")
	-- 		vim.g.vimtex_quickfix_open_on_warning = 0
	-- 	end,
	-- },
	{ "lewis6991/gitsigns.nvim", opts = { current_line_blame_opts = { delay = 0 } } },
	{
		"lewis6991/satellite.nvim",
		opts = { current_only = true, excluded_filetypes = { "snacks_picker_list" } },
		init = function()
			vim.api.nvim_create_autocmd("BufWinEnter", {
				callback = function()
					vim.cmd(":SatelliteRefresh")
				end,
			})
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		opts = { default_mappings = false },
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
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {},
	},
	{
		"otavioschwanck/arrow.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		opts = {
			show_icons = true,
			hide_handbook = true,
			leader_key = KEYMAPS.arrow.leader_key,
			separate_save_and_remove = true,
			mappings = KEYMAPS.arrow.mappings,
			window = {
				border = "rounded",
			},
		},
	},
	{
		-- brew install pngpaste on mac
		"HakonHarnes/img-clip.nvim",
		opts = {
			default = {
				insert_mode_after_paste = false,
				prompt_for_file_name = false,
			},
		},
	},
	{
		"Darazaki/indent-o-matic",
	},
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
	},
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		opts = {},
	},
}
