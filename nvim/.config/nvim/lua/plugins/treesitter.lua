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
