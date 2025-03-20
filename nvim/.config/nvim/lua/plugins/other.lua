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
}
