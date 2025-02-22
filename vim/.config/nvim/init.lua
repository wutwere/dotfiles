---@diagnostic disable: missing-fields
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
	{ "saghen/blink.compat", version = "*" },
	{ "Exafunction/codeium.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
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
	{ "MagicDuck/grug-far.nvim", opts = { windowCreationCommand = "e" } },
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.cmd("call mkdp#util#install()")
		end,
	},
}

local KEYMAPS = {}
do
	vim.g.mapleader = " "
	vim.g.maplocalleader = "\\"
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
		set("t", "<esc>", "<cmd>bd!<cr>")

		-- fast navigation
		set({ "n", "v", "x" }, "<c-j>", "7<c-e>")
		set({ "n", "v", "x" }, "<c-k>", "7<c-y>")
		set("n", "<c-h>", "<c-w>W")
		set("n", "<c-l>", "<c-w>w")
		set("n", "gb", "<cmd>b#<cr>")
		set("n", "]b", "<cmd>bn<cr>")
		set("n", "[b", "<cmd>bp<cr>")

		-- fzf
		set("n", "<leader>a", "<cmd>FzfLua<cr>")
		set("n", "<leader>f", "<cmd>FzfLua files<cr>")
		set("n", "<leader>b", "<cmd>FzfLua buffers<cr>")
		set("n", "<leader>z", "<cmd>FzfLua zoxide<cr>")
		set("n", "<leader>/", "<cmd>FzfLua treesitter<cr>")
		set("v", "<leader>/", "<cmd>FzfLua grep_visual<cr>")

		-- find and replace
		set("n", "<leader>r", "<cmd>GrugFar<cr>")

		-- git
		set("n", "<leader>gg", "<cmd>Neogit<cr>")
		set("n", "<leader>gd", "<cmd>Neogit diff<cr>")
		set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>")
		set("n", "]g", "<cmd>Gitsigns nav_hunk next<cr><cmd>Gitsigns preview_hunk_inline<cr>")
		set("n", "[g", "<cmd>Gitsigns nav_hunk prev<cr><cmd>Gitsigns preview_hunk_inline<cr>")
	end

	KEYMAPS.mini_files = function(mini_files)
		mini_files.config.mappings.close = "<esc>"
		set("n", "<leader><space>", function()
			mini_files.open(vim.fn.expand("%:p:h"), false)
		end)
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
		set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", opts)
		set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", opts)
		set("n", "go", "<cmd>FzfLua lsp_type_defs<cr>", opts)
		set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opts)
		set("n", "gs", vim.lsp.buf.signature_help, opts)
		set("n", "<leader>2", vim.lsp.buf.rename, opts)
		set({ "n", "x" }, "<leader>3", vim.lsp.buf.format, opts)
		set("n", "<leader>4", "<cmd>FzfLua lsp_code_actions<cr>", opts)
	end

	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	KEYMAPS.cmp = {
		preset = "none",
		["<cr>"] = { "accept", "fallback" },
		["<tab>"] = {
			function(cmp)
				if has_words_before() and not cmp.is_visible() then
					return cmp.show()
				elseif cmp.is_visible() then
					return cmp.select_next()
				end
				return nil
			end,
			"fallback",
		},
		["<S-tab>"] = { "show", "select_prev", "fallback" },
		["<C-j>"] = { "scroll_documentation_down" },
		["<C-k>"] = { "scroll_documentation_up" },
	}
end

KEYMAPS.general()

-----------------
-- VIM OPTIONS --
-----------------

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
require("lualine").setup({
	options = { theme = theme, always_show_tabline = false, globalstatus = true },
	sections = {
		lualine_a = { "mode" },
		lualine_b = { { "buffers", use_mode_colors = true } },
		lualine_c = {},
		lualine_x = { "encoding", "fileformat", "filetype", "branch", "diff", "diagnostics", "progress" },
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = { lualine_a = { { "tabs", mode = 2, use_mode_colors = true, max_length = vim.o.columns } } },
})
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
	flags = { debounce_text_changes = 150 },
}
local custom_config = {
	luau_lsp = {
		cmd = { "luau-lsp", "lsp", "--definitions=~/roblox/globalTypes.d.luau", "--docs=~/roblox/en-us.json" },
	},
	lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
	clangd = {},
	pyright = {},
	vtsls = {},
	rust_analyzer = {
		on_init = function(client, _)
			--client.server_capabilities.semanticTokensProvider = nil
		end,
	},
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
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},
		ghost_text = { enabled = true },
	},
	signature = {
		enabled = true,
		window = { border = "rounded" },
	},
	keymap = KEYMAPS.cmp,
	sources = {
		default = {
			"lazydev",
			"codeium",
			"lsp",
			"path",
			"snippets",
			"buffer", --[["cmdline"]]
		},
		providers = {
			lsp = { score_offset = 90 },
			lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 91 },
			codeium = {
				name = "codeium",
				module = "blink.compat.source",
				score_offset = 100,
				async = true,
			},
		},
	},
})

require("blink-compat").setup({ impersonate_nvim_cmp = true })
require("codeium").setup({})

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
