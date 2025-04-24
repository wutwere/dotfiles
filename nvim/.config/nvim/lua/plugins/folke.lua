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
			indent = { enabled = true },
			input = {
				enabled = true,
				expand = false,
			},
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			picker = {
				enabled = true,
				sources = {
					files = {
						hidden = true,
					},
				},
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = {
				enabled = false,
				animate = {
					duration = { step = 10, total = 150 },
					easing = "linear",
				},
				-- faster animation when repeating scroll after delay
				animate_repeat = {
					delay = 10000000, -- delay in ms before using the repeat animation
					duration = { step = 10, total = 150 },
					easing = "linear",
				},
			},
			statuscolumn = { enabled = true },
			words = { enabled = true },
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

					KEYMAPS.snacks(Snacks)
				end,
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = { preset = "modern", delay = 300 },
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
}
