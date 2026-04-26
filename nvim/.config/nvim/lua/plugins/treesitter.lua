--disable missing fields from LSP
---@diagnostic disable: missing-fields

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local langs = {
				"bash",
				"cpp",
				"css",
				"fish",
				"go",
				"java",
				"javascript",
				"json",
				"lua",
				"luau",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"ruby",
				"rust",
				"tsx",
				"typescript",
				"yaml",
				"zig",
			}
			require("nvim-treesitter").install(langs)
			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = langs,
				callback = function(args)
					local buf = args.buf
					local ft = vim.bo[buf].filetype
					if ft == "latex" then
						return true
					end
					local max_filesize = 3 * 1024 * 1024
					local ok, size = pcall(vim.fn.getfsize, vim.api.nvim_buf_get_name(buf))
					if not (ok and (size == -2 or size > max_filesize)) then
						vim.treesitter.start()
					end
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					require("nvim-treesitter.parsers").luau = {
						---@diagnostic disable-next-line missing-fields
						install_info = {
							-- IMPORTANT: need queries/luau/ to be able to use this
							url = "https://github.com/polychromatist/tree-sitter-luau", -- git repo
							revision = "71b03e66b2c8dd04e0133c9b998a54a58f239ca4",
						},
						-- WARN: `tier = 2` is important for custom parsers
						-- `norm_languages()` in config.lua checks vor `tier < 4`
						-- see: https://github.com/nvim-treesitter/nvim-treesitter/blob/0140c29b31d56be040697176ae809ba0c709da02/lua/nvim-treesitter/config.lua#L95
						-- tiers: 1: stable, 2: unstable, 3: unmaintained, 4 or nil: unsupported
						--        supported = tier < 4
						tier = 2,
					}
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						include_surrounding_whitespace = false,
					},
				},
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context", opts = { mode = "topline" } },
}
