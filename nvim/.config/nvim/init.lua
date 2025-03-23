local KEYMAPS = require("config.keymaps")
KEYMAPS.general()

-----------------
-- VIM OPTIONS --
-----------------

vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.cindent = true
vim.opt.cinoptions = { "N-s", "g0", "j1", "(s", "m1" }
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 10
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.laststatus = 3
vim.opt.mouse = "nv"
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
	callback = function()
		vim.opt.nu = true
		vim.opt.rnu = true
		vim.cmd("hi cursorline guibg=NONE")
		-- Reserve a space in the gutter
		-- This will avoid an annoying layout shift in the screen
		vim.opt.signcolumn = "yes" -- (lsp-zero told me to do this)
		-- vim.cmd("ColorizerAttachToBuffer")
	end,
})

---------------
-- LAZY.NVIM --
---------------

do
	-- Auto-install lazy.nvim if not present
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.uv.fs_stat(lazypath) then
		print("Installing lazy.nvim....")
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath,
		})
		print("Done.")
	end

	vim.opt.rtp:prepend(lazypath)
end

require("lazy").setup({ spec = { import = "plugins" }, ui = { border = "rounded" } })

----------------
-- APPEARANCE --
----------------

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank({ higroup = "Cursor", timeout = 60 })
	end,
})

vim.diagnostic.config({
	float = {
		border = "rounded",
		source = true,
	},
})

-- color scheme only works properly if loaded last for some reason

require("rose-pine").setup({
	variant = "auto", -- auto, main, moon, or dawn
	dark_variant = "main", -- main, moon, or dawn
	dim_inactive_windows = false,
	extend_background_behind_borders = true,

	enable = {
		terminal = true,
		legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
		migrations = true, -- Handle deprecated options automatically
	},

	styles = {
		bold = true,
		italic = false,
		transparency = true,
	},

	groups = {
		border = "muted",
		link = "iris",
		panel = "surface",

		error = "love",
		hint = "iris",
		info = "foam",
		note = "pine",
		todo = "rose",
		warn = "gold",

		git_add = "foam",
		git_change = "rose",
		git_delete = "love",
		git_dirty = "rose",
		git_ignore = "muted",
		git_merge = "iris",
		git_rename = "pine",
		git_stage = "iris",
		git_text = "rose",
		git_untracked = "subtle",

		h1 = "iris",
		h2 = "foam",
		h3 = "rose",
		h4 = "gold",
		h5 = "pine",
		h6 = "foam",
	},

	palette = {
		-- Override the builtin palette per variant
		-- moon = {
		--     base = '#18191a',
		--     overlay = '#363738',
		-- },
	},

	-- NOTE: Highlight groups are extended (merged) by default. Disable this
	-- per group via `inherit = false`
	highlight_groups = {
		-- Comment = { fg = "foam" },
		-- StatusLine = { fg = "love", bg = "love", blend = 15 },
		-- VertSplit = { fg = "muted", bg = "muted" },
		-- Visual = { fg = "base", bg = "text", inherit = false },
		NotifyBackground = { bg = "surface" },
	},

	before_highlight = function(group, highlight, palette)
		-- Disable all undercurls
		-- if highlight.undercurl then
		--     highlight.undercurl = false
		-- end
		--
		-- Change palette colour
		-- if highlight.fg == palette.pine then
		--     highlight.fg = palette.foam
		-- end
	end,
})

vim.cmd("colorscheme rose-pine")
