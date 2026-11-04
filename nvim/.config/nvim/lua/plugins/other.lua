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
		-- Zoomed-out view of the file: <leader>M opens it focused, move to scroll the
		-- source, <CR> to jump there, <Esc> to go back. Closes when it loses focus.
		"echasnovski/mini.map",
		keys = {
			{
				"<leader>M",
				function()
					local map = require("mini.map")
					map.open()
					-- open() renders on the next tick from the current window; focusing
					-- the map before that leaves it empty.
					vim.schedule(map.toggle_focus)
				end,
				desc = "Minimap",
			},
		},
		config = function()
			local map = require("mini.map")
			map.setup({
				integrations = {
					map.gen_integration.builtin_search(),
					map.gen_integration.diagnostic(),
					map.gen_integration.gitsigns(),
				},
				symbols = { encode = map.gen_encode_symbols.dot("4x2") },
				window = { width = 24, winblend = 0, show_integration_count = false },
			})
			vim.api.nvim_create_autocmd("WinLeave", {
				callback = function()
					if vim.bo.filetype == "minimap" then
						vim.schedule(map.close)
					end
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
		opts = {
			diff = {
				layout = "inline",
				max_computation_time_ms = 100,
				ignore_trim_whitespace = true,
				cycle_hunks_across_files = true,
				compact_context_lines = 5,
				compact_sync_folds = false,
			},
			explorer = {
				view_mode = "tree",
				position = "bottom",
				focus_on_select = true,
				line_stats = {
					enabled = true,
					count_untracked = true,
				},
			},
		},
	},
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		opts = {},
	},
}
