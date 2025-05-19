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
			if default_config.capabilities.workspace == nil then
				default_config.capabilities.workspace = {}
			end
			default_config.capabilities.workspace.didChangeWatchedFiles = {
				dynamicRegistration = true,
			}
			local custom_config = {
				luau_lsp = {
					cmd = {
						"luau-lsp",
						"lsp",
						"--definitions=~/.luau-lsp/globalTypes.d.luau",
						"--docs=~/.luau-lsp/en-us.json",
					},
					settings = {
						["luau-lsp"] = {
							completion = {
								enableFragmentAutocomplete = true,
								imports = {
									enabled = true,
								},
							},
						},
					},
				},
				lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
				clangd = {},
				pyright = {},
				vtsls = {},
				jsonls = {},
				rust_analyzer = { settings = { ["rust-analyzer"] = { check = { command = "clippy" } } } },
				texlab = {},
				biome = {},
				ruby_lsp = {},
				standardrb = {},
				-- sorbet = { cmd = { "srb", "tc", "--lsp", "--disable-watchman", "." } },
				jdtls = {
					on_init = function(client, _)
						client.server_capabilities.semanticTokensProvider = nil
					end,
				},
			}

			for lsp, config in pairs(custom_config) do
				for k, v in pairs(default_config) do
					if not config[k] then
						config[k] = v
					end
				end
				-- lspconfig[lsp].setup(config)
				vim.lsp.config(lsp, config)
				vim.lsp.enable(lsp)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					KEYMAPS.lsp(event)
				end,
			})
		end,
	},
	{ "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
	-- {
	-- 	"williamboman/mason-lspconfig.nvim",
	-- 	opts = {
	-- 		automatic_installation = true,
	-- 	},
	-- },
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
			-- format_on_save = {
			-- 	timeout_ms = 500,
			-- 	lsp_format = "fallback",
			-- },
			format_after_save = {
				lsp_format = "fallback",
				async = true,
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
	{
		"j-hui/fidget.nvim",
		opts = { notification = { window = { winblend = 0 } } },
	},
}
