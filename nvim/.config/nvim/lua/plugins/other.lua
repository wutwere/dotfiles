local KEYMAPS = require("config.keymaps")

return {
	{ "ThePrimeagen/vim-be-good" },
	{
		"echasnovski/mini.files",
		config = function()
			local mini_files = require("mini.files")
			mini_files.setup({
				windows = {
					preview = true,
					width_preview = 30,
					width_nofocus = 30,
					width_focus = 30,
				},
			})
			KEYMAPS.mini_files(mini_files)
		end,
	},
	{ "MagicDuck/grug-far.nvim", opts = { windowCreationCommand = "e" } },
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.opt.conceallevel = 1
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

			-- Customize how cursors look.
			-- local hl = vim.api.nvim_set_hl
			-- hl(0, "MultiCursorCursor", { link = "Cursor" })
			-- hl(0, "MultiCursorVisual", { link = "Visual" })
			-- hl(0, "MultiCursorSign", { link = "SignColumn" })
			-- hl(0, "MultiCursorMatchPreview", { link = "Search" })
			-- hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
			-- hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			-- hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},
}
