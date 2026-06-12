local KEYMAPS = require("config.keymaps")

return {
	{ "ThePrimeagen/vim-be-good" },
	-- {
	-- 	"echasnovski/mini.files",
	-- 	config = function()
	-- 		local mini_files = require("mini.files")
	-- 		mini_files.setup({
	-- 			windows = {
	-- 				max_number = 2,
	-- 				preview = true,
	-- 				width_preview = 30,
	-- 				width_nofocus = 50,
	-- 				width_focus = 50,
	-- 			},
	-- 			options = {
	-- 				permanent_delete = false,
	-- 			},
	-- 		})
	-- 		KEYMAPS.mini_files()
	-- 	end,
	-- },
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			default_file_explorer = true,
			columns = {
				"icon",
			},
			delete_to_trash = true,
			view_options = {
				show_hidden = true,
			},
			win_options = {
				winbar = "%!v:lua.get_oil_winbar()",
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			function _G.get_oil_winbar()
				local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
				local dir = require("oil").get_current_dir(bufnr)
				if dir then
					return vim.fn.fnamemodify(dir, ":~")
				else
					-- If there is no current directory (e.g. over ssh), just show the buffer name
					return vim.api.nvim_buf_get_name(0)
				end
			end
			KEYMAPS.oil()
		end,
	},
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
}
