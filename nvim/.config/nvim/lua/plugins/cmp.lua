local KEYMAPS = require("config.keymaps")

return {
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
}
