--// Dependencies:
--// - Neovim v0.10+
--// - fzf

-----------------
-- MAIN CONFIG --
-----------------

local PLUGINS = {
	{ "tomasr/molokai" },
	{ "folke/tokyonight.nvim" },
	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "ThePrimeagen/vim-be-good" },
	{ "nvim-treesitter/nvim-treesitter" },
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "mfussenegger/nvim-lint" },
	{ "stevearc/conform.nvim" },
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { previewers = { builtin = { syntax_limit_b = 100 * 1024 } } },
	},
	{ "echasnovski/mini.files" },
	{ "saghen/blink.cmp", version = "*" },
	{ "zbirenbaum/copilot.lua" },
	{ "fang2hou/blink-copilot" },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
	},
	{
		"NeogitOrg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "ibhagwan/fzf-lua" },
		config = true,
	},
}

local KEYMAPS = {}
do
	vim.g.mapleader = " "
	local set = vim.keymap.set

	KEYMAPS.general = function()
		-- editor
		set("i", "{<cr>", "{<cr>}<esc>O")
		set("n", "<leader>y", "<cmd>%y+<cr>")
		set("n", "<leader>m", "<cmd>e $MYVIMRC<cr>")
		set("n", "<leader>d", vim.diagnostic.open_float)
		set("n", "<leader>w", "<cmd>tabc<cr>")

		-- terminal
		set("n", "<leader>t", "<cmd>vs<cr><cmd>term<cr>a")
		set("t", "<esc>", "<c-\\><c-n>")

		-- fast navigation
		set({ "n", "v", "x" }, "<c-j>", "7<c-e>")
		set({ "n", "v", "x" }, "<c-k>", "7<c-y>")
		set("n", "<c-h>", "<c-w>W")
		set("n", "<c-l>", "<c-w>w")

		-- fzf
		set("n", "<leader>a", "<cmd>FzfLua<cr>")
		set("n", "<leader>f", "<cmd>FzfLua files<cr>")

		-- git
		set("n", "<leader>gg", "<cmd>Neogit<cr>")
		set("n", "<leader>gd", "<cmd>Neogit diff<cr>")
	end

	KEYMAPS.mini_files = function(mini_files)
		mini_files.config.mappings.close = "<esc>"
		set("n", "<leader><space>", mini_files.open)
		set("n", "<leader>s", function() -- set working dir to current buffer
			local state = mini_files.get_explorer_state()
			local dir = state and state.branch[state.depth_focus] or "%:h"
			vim.cmd("cd " .. dir)
			vim.cmd("pwd")
		end)
	end

	KEYMAPS.lsp = function(event)
		local opts = { buffer = event.buf }
		set("n", "K", vim.lsp.buf.hover, opts)
		set("n", "gd", vim.lsp.buf.definition, opts)
		set("n", "gi", vim.lsp.buf.implementation, opts)
		set("n", "go", vim.lsp.buf.type_definition, opts)
		set("n", "gr", vim.lsp.buf.references, opts)
		set("n", "gs", vim.lsp.buf.signature_help, opts)
		set("n", "<f2>", vim.lsp.buf.rename, opts)
		set({ "n", "x" }, "<f3>", vim.lsp.buf.format, opts)
		set("n", "<f4>", vim.lsp.buf.code_action, opts)
	end

	KEYMAPS.cmp = {
		["<cr>"] = { "accept", "fallback" },
		["<tab>"] = { "show", "select_next", "fallback" },
		["<S-tab>"] = { "show", "select_prev", "fallback" },
	}
end

-----------------
-- VIM OPTIONS --
-----------------

vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.cindent = true
vim.opt.cinoptions = { "N-s", "g0", "j1", "(s", "m1" }
vim.opt.scrolloff = 5
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.laststatus = 3
vim.opt.mouse = "nv"
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
	callback = function()
		vim.opt.nu = true
		vim.opt.rnu = true
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

require("lazy").setup(PLUGINS)

----------------
-- APPEARANCE --
----------------

vim.diagnostic.config({
	float = {
		border = "rounded",
		source = true,
	},
})

-- Auto match terminal padding color
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

local theme = require("lualine.themes.tokyonight")
theme.normal.c.bg = nil
require("lualine").setup({ options = { theme = theme } })
require("tokyonight").setup({ transparent = true, styles = { floats = "transparent" } })
vim.cmd.colorscheme("tokyonight-night")

-------------
-- LINTING --
-------------

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

----------------
-- FORMATTING --
----------------

local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		luau = { "stylua" },
	},
})
conform.setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

---------
-- LSP --
---------

require("mason").setup()
require("mason-lspconfig").setup({
	automatic_installation = true,
})
local lspconfig = require("lspconfig")
local default_config = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	flags = {
		debounce_text_changes = 0, --150,
	},
}
local custom_config = {
	luau_lsp = {
		cmd = { "luau-lsp", "lsp", "--definitions=~/roblox/globalTypes.d.luau", "--docs=~/roblox/en-us.json" },
	},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = {
						"vim",
					},
				},
			},
		},
	},
	clangd = {
		-- on_init = function(client, _) client.server_capabilities.semanticTokensProvider = nil end,
	},
	pyright = {},
	vtsls = {},
	rust_analyzer = {},
}

for lsp, config in pairs(custom_config) do
	setmetatable(config, { __index = default_config })
	lspconfig[lsp].setup(config)
end

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = "yes" -- (lsp-zero told me to do this)

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		KEYMAPS.lsp(event)
	end,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

------------------
-- AUTOCOMPLETE --
------------------

require("blink-cmp").setup({
	completion = {
		trigger = { show_on_blocked_trigger_characters = {} },
		documentation = { auto_show = true, auto_show_delay_ms = 0, window = { border = "rounded" } },
		menu = {
			border = "rounded",
			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "source_name" },
				},
			},
		},
		list = { selection = {
			preselect = false,
			auto_insert = false,
		} },
		ghost_text = { enabled = true },
	},
	signature = {
		enabled = true,
		window = { border = "rounded" },
	},
	keymap = KEYMAPS.cmp,
	sources = {
		default = { "lazydev", "copilot", "lsp", "path", "snippets", "buffer", "cmdline" },
		providers = {
			cmdline = { score_offset = -10 },
			lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 90 },
			copilot = { name = "copilot", module = "blink-copilot", score_offset = 100, async = true },
		},
	},
})

require("copilot").setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})

----------------
-- TREESITTER --
----------------

require("nvim-treesitter.configs").setup({
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

----------------
-- MINI.FILES --
----------------

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

KEYMAPS.general()
