local KEYMAPS = require("config.keymaps")
KEYMAPS.general()

-----------------
-- VIM OPTIONS --
-----------------

if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "win32yank",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fillchars = { eob = " " }
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
vim.opt.mouse = "nv"
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.sidescrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = "block"
vim.opt.winborder = "rounded"
vim.opt.wrap = false
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.wrap = true
	end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "o", "r" })
		vim.opt.number = true
		vim.opt.relativenumber = true
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
		source = true,
	},
})

-- vim.cmd("colorscheme rose-pine-moon")
vim.cmd("colorscheme monokai-pro-classic")
