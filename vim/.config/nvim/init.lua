--[[

basic nvim config with lsp, treesitter for highlighting, fzf, and autocomplete
remember to get a nerd font https://www.nerdfonts.com/font-downloads

install nvim 0.10.4:
wget 'https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz'
tar xvzf nvim-linux-x86_64.tar.gz
move it to opt, export path to opt/whatever/bin

install fzf:
sudo apt install fzf

remember for new languages: install + add lsp and :TSInstall

--]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto-install lazy.nvim if not present
if not vim.uv.fs_stat(lazypath) then
	print("Installing lazy.nvim....")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
	print("Done.")
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "tomasr/molokai" },
	{ "folke/tokyonight.nvim" },
	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "ThePrimeagen/vim-be-good" },
	{ "nvim-treesitter/nvim-treesitter" },
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "mfussenegger/nvim-lint" },
	{ "stevearc/conform.nvim" },
	{ "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "echasnovski/mini.files" },
	{ "Exafunction/codeium.nvim", dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" } },
})

vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
	callback = function()
		local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
		if not normal.bg then
			return
		end
		io.write(string.format("\027]11;#%06x\027\\", normal.bg))
	end,
})

vim.api.nvim_create_autocmd("UILeave", {
	callback = function()
		io.write("\027]111\027\\")
	end,
})

-- appearance
require("lualine").setup({ options = { theme = require("lualine.themes.palenight") } })
require("tokyonight").setup({ transparent = true })
vim.cmd.colorscheme("tokyonight-night")

-- editor keybinds
vim.g.mapleader = " "
vim.keymap.set("i", "{<cr>", "{<cr>}<esc>O")
vim.keymap.set("n", "<C-a>", "<cmd>%y+<cr>")

-- TODO: detect windows and add competitive programming keybinds

-- preferences
local function options()
	vim.opt.termguicolors = true
	vim.opt.nu = true
	vim.opt.rnu = true
	vim.opt.expandtab = true
	vim.opt.cindent = true
	vim.opt.cinoptions = { "N-s", "g0", "j1", "(s", "m1" }
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	-- vim.opt.mouse = 'a' -- why is this enabled by default now
end
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
	callback = options,
})

-- linting
local lint = require("lint")
lint.linters_by_ft = {
	lua = { "selene" },
	luau = { "selene" },
}
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		lint.try_lint()
	end,
})

-- formatting
local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		luau = { "stylua" },
	},
})
conform.setup({
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- fuzzy finder
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua<cr>")
vim.keymap.set("n", "<C-p>", "<cmd>FzfLua files<cr>")

-- file editing
require("mini.files").setup()
vim.keymap.set("n", "<leader>q", MiniFiles.open)
vim.keymap.set("n", "<leader>s", function()
	local state = MiniFiles.get_explorer_state()
	if state then
		vim.cmd("cd " .. state.branch[state.depth_focus])
	else
		vim.cmd("cd %:h")
	end
	vim.cmd("pwd")
end)

---------------------------------------------
-- EVERYTHING BELOW IS STUFF FROM LSP-ZERO --
---------------------------------------------

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = "yes"

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities =
	vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	end,
})

-- why does lsp add delay when entering into a file
local lspconfig = require("lspconfig")
local default_config = {
	flags = {
		debounce_text_changes = 150,
	},
}
local custom_config = {
	luau_lsp = {
		cmd = { "luau-lsp", "lsp", "--definitions=~/roblox/globalTypes.d.luau", "--docs=~/roblox/en-us.json" },
	},
	clangd = {
		on_init = function(client, _)
			client.server_capabilities.semanticTokensProvider = nil
		end,
	},
}

for _, lsp in ipairs({ "clangd", "pyright", "vtsls", "rust_analyzer", "luau_lsp" }) do
	local config = custom_config[lsp] or {}
	for k, v in pairs(default_config) do
		if not config[k] then
			config[k] = v
		end
	end
	lspconfig[lsp].setup(config)
end

------------------
-- AUTOCOMPLETE --
------------------

local cmp = require("cmp")

cmp.setup({
	sources = {
		{ name = "codeium" },
		{ name = "nvim_lsp" },
	},
	mapping = cmp.mapping.preset.insert({
		["<cr>"] = cmp.mapping.confirm(),
		["<tab>"] = function(_)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			else
				cmp.complete()
			end
		end,
		["<S-tab>"] = function(_)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			else
				cmp.complete()
			end
		end,
	}),
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
})

-- ai has to be after cmp
require("codeium").setup({})

----------------
-- TREESITTER --
----------------

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or 'all' (the listed parsers MUST always be installed)
	ensure_installed = { "cpp", "typescript", "tsx", "python", "luau", "javascript", "rust", "json", "lua" },
	highlight = {
		enable = true,
		disable = function(_lang, buf)
			local max_filesize = 100 * 1024
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			return ok and stats and stats.size > max_filesize
		end,
	},
})
