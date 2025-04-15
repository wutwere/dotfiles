local KEYMAPS = require("config.keymaps")
KEYMAPS.general()

-----------------
-- VIM OPTIONS --
-----------------

if vim.loop.os_uname().sysname == "Linux" then
	vim.opt.clipboard = "unnamedplus"
end
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.opt.cindent = true
vim.opt.cinoptions = { "N-s", "g0", "j1", "(s", "m1" }
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fillchars = { eob = " " }
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.mouse = "nv"
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.sidescrolloff = 10
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
	callback = function()
		vim.cmd("hi cursorline guibg=NONE")
		-- Reserve a space in the gutter
		-- This will avoid an annoying layout shift in the screen
		vim.opt.signcolumn = "yes"
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

vim.cmd("colorscheme rose-pine-moon")
