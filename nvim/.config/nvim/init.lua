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
-- vim.opt.cursorline = true
-- vim.opt.expandtab = true
vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldinner = " ", foldclose = "" }
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { tab = "  ", lead = " ", trail = "·", nbsp = "␣" }
vim.opt.mouse = "nv"
vim.opt.mousescroll = "ver:1,hor:1"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 2
vim.opt.shiftwidth = 4
vim.opt.showbreak = "↪ "
vim.opt.showcmd = false
vim.opt.sidescrolloff = 0
vim.opt.signcolumn = "no" -- signs replaced by the git bar in config.statuscolumn
vim.opt.statuscolumn = "%!v:lua.require'config.statuscolumn'.render()"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.winborder = "rounded"
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

vim.cmd.colorscheme("hearth")

-- Subtly highlight a tab character under the cursor (listchars draws tabs blank).
do
	local ns = vim.api.nvim_create_namespace("cursor_tab")
	local function set_hl()
		vim.api.nvim_set_hl(0, "CursorTab", { link = "CursorLine", default = true })
	end
	set_hl()
	vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
	vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave", "WinLeave" }, {
		callback = function(ev)
			vim.api.nvim_buf_clear_namespace(ev.buf, ns, 0, -1)
			if ev.event ~= "CursorMoved" then
				return
			end
			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			if vim.api.nvim_get_current_line():sub(col + 1, col + 1) == "\t" then
				vim.api.nvim_buf_set_extmark(ev.buf, ns, row - 1, col, { end_col = col + 1, hl_group = "CursorTab" })
			end
		end,
	})
end
