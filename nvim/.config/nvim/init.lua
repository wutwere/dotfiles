local KEYMAPS = require("config.keymaps")
KEYMAPS.general()

-----------------
-- VIM OPTIONS --
-----------------

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
-- vim.g.clipboard = "osc52"
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus" -- on windows, install win32yank
-- vim.opt.cmdheight = 0
vim.opt.confirm = true
vim.opt.cursorline = true
-- vim.opt.expandtab = true
vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldinner = " ", foldclose = "" }
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { tab = "  ", lead = "·", trail = "·", nbsp = "␣" }
vim.opt.mouse = "nv"
vim.opt.mousescroll = "ver:1,hor:1"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 0
vim.opt.shiftwidth = 4
vim.opt.showbreak = "↪ "
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.sidescrolloff = 0
vim.opt.signcolumn = "auto"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
-- vim.opt.winborder = "rounded"
vim.opt.winborder = "single"
vim.opt.wrap = true
vim.opt.wrapscan = false
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown" },
	callback = function()
		vim.opt_local.spell = true
	end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "o", "r" }) -- don't continue comments when pressing o or Enter
	end,
})

function _G.winbar()
	if vim.bo.buftype ~= "" then
		return ""
	end

	local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
	local file = vim.fn.expand("%:.")

	if file == "" then
		return cwd
	end

	return cwd .. "/" .. file .. (vim.bo.modified and " [+]" or "")
end

vim.o.winbar = "%{%v:lua.winbar()%}"

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
	signs = false,
})

-- vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme monokai-pro-classic")
-- vim.cmd("colorscheme gruvbox")
vim.cmd.colorscheme("github_dark_default")
