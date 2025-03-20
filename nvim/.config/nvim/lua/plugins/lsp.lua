local KEYMAPS = require("config.keymaps")

return {
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
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			automatic_installation = true,
		},
	},
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
}
