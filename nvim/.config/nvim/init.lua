---@diagnostic disable: missing-fields

-----------------
-- MAIN CONFIG --
-----------------

local KEYMAPS = {}
do
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	KEYMAPS.general = function()
		-- editor
		vim.keymap.set("i", "{<cr>", "{<cr>}<esc>O")
		vim.keymap.set("i", "{<s-cr>", "{<cr>}<esc>O")
		vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selected to clipboard" })
		vim.keymap.set("n", "<leader>y", "<cmd>%y+<cr>", { desc = "Copy entire file contents to clipboard" })
		vim.keymap.set("n", "<leader>Y", function()
			vim.fn.setreg("+", vim.fn.expand("%:p"))
		end, { desc = "Copy file path to clipboard" })
		vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste clipboard" })
		vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste clipboard" })
		vim.keymap.set("n", "<leader>m", "<cmd>e $MYVIMRC<cr>", { desc = "Edit vim config" })
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics at cursor" })
		vim.keymap.set("n", "<leader>w", "<cmd>tabc<cr>", { desc = "Close tab" })

		-- competitive programming
		vim.keymap.set("n", "<leader>t", function()
			vim.cmd("vsplit +term\\ ./run\\ " .. vim.fn.expand("%:r"))
			vim.cmd("startinsert!")
		end, { desc = "Run program in terminal split" })
		vim.keymap.set("t", "<esc>", "<cmd>bd!<cr>")
		vim.keymap.set("t", "<c-n>", "<c-\\><c-n>")

		-- fast navigation
		vim.keymap.set("n", "<leader>h", "<c-w>h", { desc = "Move to left pane" })
		vim.keymap.set("n", "<leader>j", "<c-w>j", { desc = "Move to lower pane" })
		vim.keymap.set("n", "<leader>k", "<c-w>k", { desc = "Move to upper pane" })
		vim.keymap.set("n", "<leader>l", "<c-w>l", { desc = "Move to right pane" })
		vim.keymap.set("n", "gb", "<cmd>b#<cr>")
		vim.keymap.set("n", "]b", "<cmd>bn<cr>")
		vim.keymap.set("n", "[b", "<cmd>bp<cr>")
		vim.keymap.set("n", "]c", "<cmd>cn<cr>")
		vim.keymap.set("n", "[c", "<cmd>cp<cr>")

		-- plugins
		vim.keymap.set("n", "<leader><space>", "<cmd>FzfLua files<cr>")
		vim.keymap.set({ "n", "v" }, "<leader>ff", "<cmd>FzfLua<cr>")
		vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<cr>")
		vim.keymap.set("n", "<leader>fj", "<cmd>FzfLua jumps<cr>")
		vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
		vim.keymap.set("n", "<leader>fz", "<cmd>FzfLua zoxide<cr>")
		vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>")
		vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua lines<cr>")
		vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>")
		vim.keymap.set("v", "<leader>fv", "<cmd>FzfLua grep_visual<cr>")

		vim.keymap.set("n", "<leader>r", "<cmd>GrugFar<cr>", { desc = "Search and replace all files" })

		vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>")
		vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>")
		vim.keymap.set("n", "<leader>gb", "<cmd>Neogit branch<cr>")
		vim.keymap.set("n", "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<cr>")
		vim.keymap.set("n", "<leader>gL", "<cmd>Gitsigns blame<cr>")
		vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>")
		vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>")

		vim.keymap.set("n", "<leader>n", "<cmd>Namu symbols<cr>", { desc = "Open LSP search" })

		vim.keymap.set("n", "<bs>", "<cmd>NoiceDismiss<cr>")
	end

	KEYMAPS.mini_files = function(mini_files)
		mini_files.config.mappings.close = "<esc>"
		vim.keymap.set("n", "-", function()
			mini_files.open(vim.fn.expand("%:p:h"), false)
		end, { desc = "Open file explorer" })
		vim.keymap.set("n", "<leader>-", function()
			local state = mini_files.get_explorer_state()
			local dir = state and state.branch[state.depth_focus] or "%:h"
			vim.cmd("cd " .. dir)
			vim.cmd("pwd")
		end, { desc = "Set working directory here" })
	end

	KEYMAPS.lsp = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Show LSP hover at cursor" })
		vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>FzfLua lsp_type_defs<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opts)
		vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = event.buf, desc = "Go to signature help" })
		vim.keymap.set("n", "<leader>2", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename reference" })
		vim.keymap.set({ "n", "x" }, "<leader>3", vim.lsp.buf.format, { buffer = event.buf, desc = "Format file" })
		vim.keymap.set(
			"n",
			"<leader>4",
			"<cmd>FzfLua lsp_code_actions<cr>",
			{ buffer = event.buf, desc = "Show code actions" }
		)
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
					return cmp.show() and cmp.select_next()
				elseif cmp.is_visible() then
					return cmp.select_next()
				end
				return nil
			end,
		},
		["<S-tab>"] = { "show", "select_prev", "fallback" },
		["<C-j>"] = { "scroll_documentation_down" },
		["<C-k>"] = { "scroll_documentation_up" },
	}
end

KEYMAPS.general()

local PLUGINS = {
	{ "folke/tokyonight.nvim", opts = { transparent = true, styles = { floats = "transparent" } } },
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function(_, opts)
			require("lualine").setup({
				options = {
					theme = (function()
						local theme = require("lualine.themes.rose-pine")
						theme.normal.c.bg = nil
						return theme
					end)(),
					always_show_tabline = false,
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { { "buffers", use_mode_colors = true, max_length = vim.o.columns / 2 } },
					lualine_c = {},
					lualine_x = { --[["encoding", "fileformat", "filetype",]]
						"branch",
						"diff",
						"diagnostics",
						"progress",
					},
					lualine_y = {
						{
							require("noice").api.statusline.mode.get,
							cond = function()
								local noice_status = require("noice").api.statusline
								return noice_status.mode.has() and noice_status.mode.get():sub(1, 3) == "rec"
							end,
							color = { fg = "#ff9e64" },
						},
					},
					lualine_z = { "location" },
				},
				tabline = { lualine_a = { { "tabs", mode = 2, use_mode_colors = true, max_length = vim.o.columns } } },
			})
		end,
	},
	{ "ThePrimeagen/vim-be-good" },
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"cpp",
					"typescript",
					"tsx",
					"python",
					"luau",
					"javascript",
					"rust",
					"json",
					"lua",
					"latex",
				},
				highlight = {
					enable = true,
					disable = function(lang, buf)
						if lang == "latex" then
							return true
						end
						local max_filesize = 100 * 1024
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						return ok and stats and stats.size > max_filesize
					end,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						node_incremental = "v",
						node_decremental = "V",
					},
				},
				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = { query = "@function.outer", desc = "function" },
							["if"] = { query = "@function.inner", desc = "inner function" },
							["ac"] = { query = "@class.outer", desc = "class" },
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "inner class" },
							-- You can also use captures from other query groups like `locals.scm`
							["al"] = { query = "@local.scope", query_group = "locals", desc = "scope" },
						},
					},
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local default_config = {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				flags = { debounce_text_changes = 1000 },
				-- on_init = function(client, _)
				-- 	client.server_capabilities.semanticTokensProvider = nil
				-- end,
			}
			local custom_config = {
				luau_lsp = {
					cmd = {
						"luau-lsp",
						"lsp",
						"--definitions=~/roblox/globalTypes.d.luau",
						"--docs=~/roblox/en-us.json",
					},
				},
				lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
				clangd = {},
				pyright = {},
				vtsls = {},
				jsonls = {},
				rust_analyzer = {},
				texlab = {},
			}

			for lsp, config in pairs(custom_config) do
				for k, v in pairs(default_config) do
					if not config[k] then
						config[k] = v
					end
				end
				lspconfig[lsp].setup(config)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					KEYMAPS.lsp(event)
				end,
			})

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
		end,
	},
	{ "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
	{ "williamboman/mason-lspconfig.nvim", opts = {
		automatic_installation = true,
	} },
	{
		"mfussenegger/nvim-lint",
		config = function()
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
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				luau = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			previewers = { builtin = { syntax_limit_b = 100 * 1024 } },
			grep = {
				rg_opts = "--color=always --hidden --line-number --smart-case --no-heading --column",
			},
			files = {
				fd_opts = "--color=never --type f --hidden --follow --exclude .git",
				rg_opts = "--color=never --files --hidden --follow -g '!.git'",
			},
		},
	},
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
	{
		"saghen/blink.cmp",
		version = "*",
		opts = {
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 0, window = { border = "rounded" } },
				menu = {
					-- auto_show = false,
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
					"markdown",
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
					markdown = {
						name = "RenderMarkdown",
						module = "render-markdown.integ.blink",
						score_offset = 91,
						fallbacks = { "lsp" },
					},
				},
			},
		},
	},
	{ "saghen/blink.compat", version = "*", opts = { impersonate_nvim_cmp = true } },
	{ "Exafunction/codeium.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
	},
	{
		"NeogitOrg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "ibhagwan/fzf-lua" },
		config = true,
		opts = { kind = "floating", commit_editor = { kind = "floating" } },
	},
	{ "MagicDuck/grug-far.nvim", opts = { windowCreationCommand = "e" } },
	{ "lewis6991/gitsigns.nvim", opts = { current_line_blame_opts = { delay = 0 } } },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.cmd("call mkdp#util#install()")
		end,
	},
	{
		"bassamsdata/namu.nvim",
		opts = {
			namu_symbols = {
				options = {
					movement = {
						next = { "<C-j>", "<DOWN>" },
						previous = { "<C-k>", "<UP>" },
					},
				},
			},
		},
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = { signature = { enabled = false }, hover = { enabled = false } },
			presets = { bottom_search = true },
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
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
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {
			render_modes = { "n", "c", "t", "R", "i" },
			heading = { width = "block" },
		},
	},
	{
		"karb94/neoscroll.nvim",
		opts = { duration_multiplier = 0.5 },
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = { delay = 300 },
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{ "norcalli/nvim-colorizer.lua", opts = {} },
}

-----------------
-- VIM OPTIONS --
-----------------

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
		vim.cmd("ColorizerAttachToBuffer")
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

require("lazy").setup({ spec = PLUGINS, ui = { border = "rounded" } })

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

-- local theme = require("lualine.themes.tokyonight")

-- vim.cmd.colorscheme("tokyonight-night")

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
		italic = true,
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
-- vim.cmd("colorscheme rose-pine-main")
-- vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme rose-pine-dawn")

---------
-- LSP --
---------

-- require("mason").setup()
-- require("mason-lspconfig").setup()

------------------
-- AUTOCOMPLETE --
------------------

-- require("blink-compat").setup()
-- require("codeium").setup({})

----------------
-- TREESITTER --
----------------

----------------
-- MINI.FILES --
----------------
