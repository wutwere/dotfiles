local KEYMAPS = require("config.keymaps")
local home = vim.fn.expand("~")

---@class UserLspServerConfig: vim.lsp.ClientConfig
---@field cmd? string[]|fun(dispatchers: vim.lsp.rpc.Dispatchers, config: vim.lsp.ClientConfig): vim.lsp.rpc.PublicClient

---@type table<string, UserLspServerConfig>
local server_overrides = {
	luau_lsp = {
		cmd = {
			"luau-lsp",
			"lsp",
			"--definitions=@roblox=" .. home .. "/.luau-lsp/globalTypes.d.luau",
			"--docs=" .. home .. "/.luau-lsp/en-us.json",
			-- "--definitions=@zune=~/.zune/typedefs/global/zune.d.luau",
			-- "--docs=~/.zune/typedefs/global/zune.d.json",
		},
		settings = {
			["luau-lsp"] = {
				completion = {
					imports = {
						enabled = true,
					},
					enableFragmentAutocomplete = false,
				},
				diagnostics = {
					workspace = false,
				},
			},
		},
		root_markers = { "selene.toml", ".luaurc", "stylua.toml", "src", ".git" },
		init_options = {
			fflags = {
				LuauSolverV2 = "true", -- this is so bad
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				hover = { enumsLimit = 100, previewFields = 100 },
			},
		},
	},
	clangd = {},
	pyright = {},
	vtsls = {},
	jsonls = {},
	rust_analyzer = { settings = { ["rust-analyzer"] = { check = { command = "clippy" } } } },
	texlab = {},
	biome = {},
	-- ruby_lsp = {},
	-- standardrb = {},
	-- sorbet = { cmd = { "srb", "tc", "--lsp", "--disable-watchman", "." } },
	jdtls = {
		on_init = function(client, _)
			client.server_capabilities.semanticTokensProvider = nil
		end,
	},
	nixd = {
		settings = {
			nixd = {
				nixpkgs = {
					expr = "import <nixpkgs> { }",
				},
				formatting = {
					command = { "nixfmt" },
				},
				options = {
					nixos = {
						expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
					},
					home_manager = {
						expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
					},
				},
			},
		},
	},
	gopls = {},
	buf_ls = {},
	ruff = {},
	bashls = {},
	zls = {},
}

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.lsp.config("*", {
				flags = { debounce_text_changes = 300 },
				capabilities = {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				},
			})

			for server_name, server_config in pairs(server_overrides) do
				vim.lsp.config(server_name, server_config)
				vim.lsp.enable(server_name)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					KEYMAPS.lsp(event)
				end,
			})

			vim.api.nvim_create_autocmd("BufEnter", {
				desc = "Refresh pull diagnostics",
				callback = function(args)
					if vim.api.nvim_get_option_value("buftype", { buf = args.buf }) ~= "" then
						return
					end

					for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
						if client:supports_method("textDocument/diagnostic", args.buf) then
							vim.lsp.diagnostic._refresh(args.buf, client.id)
						end
					end
				end,
			})
		end,
	},
	{ "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				go = { "golangcilint" },
				lua = { "selene" },
				luau = { "selene" },
				proto = { "buf_lint" },
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
				nix = { "alejandra" },
			},
			format_after_save = function(bufnr)
				if vim.bo[bufnr].filetype == "proto" then
					return
				end
				return {
					lsp_format = "fallback",
					async = true,
				}
			end,
		},
	},
	{
		"j-hui/fidget.nvim",
		opts = { notification = { window = { winblend = 0 } } },
	},
}
