local KEYMAPS = require("config.keymaps")

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			-- explorer = { enabled = true },
			-- indent = { enabled = true, animate = { enabled = false } },
			input = {
				enabled = true,
				expand = false,
			},
			image = { enabled = true },
			notifier = {
				enabled = true,
				top_down = false,
				timeout = 3000,
			},
			picker = {
				enabled = true,
				sources = {
					files = {
						hidden = true,
					},
					explorer = {
						layout = { layout = { position = "right" } },
					},
				},
				previewers = {
					diff = {
						builtin = false,
						cmd = { "delta", "--paging=never" },
					},
				},
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			-- scroll = { enabled = true },
			statuscolumn = { enabled = true, left = { "fold", "git" }, right = {} },
			-- words = { enabled = true },
			styles = {
				notification = {
					-- wo = { wrap = true } -- Wrap notifications
				},
			},
			zen = { enabled = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- mini.files lsp rename integration
					vim.api.nvim_create_autocmd("User", {
						pattern = "MiniFilesActionRename",
						callback = function(event)
							Snacks.rename.on_rename_file(event.data.from, event.data.to)
						end,
					})

					KEYMAPS.snacks()
				end,
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = { preset = "helix", delay = 300, win = { border = "rounded" } },
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
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
