--disable missing fields from LSP
---@diagnostic disable: missing-fields

return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"cpp",
					"css",
					"fish",
					"go",
					"java",
					"javascript",
					"json",
					"json",
					"latex",
					"lua",
					"luau",
					"python",
					"ruby",
					"rust",
					"tsx",
					"typescript",
					"zig",
				},
				highlight = {
					enable = true,
					disable = function(lang, buf)
						if lang == "latex" then
							return true
						end
						local max_filesize = 100 * 1024
						local ok, size = pcall(vim.fn.getfsize, vim.api.nvim_buf_get_name(buf))
						return ok and (size == -2 or size > max_filesize)
					end,
				},
				incremental_selection = {
					-- crashing with nvim 0.11.1
					enable = false,
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
							["aa"] = { query = "@parameter.outer", desc = "parameter" },
							["ia"] = { query = "@parameter.inner", desc = "inner parameter" },
						},
					},
				},
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	-- { "nvim-treesitter/nvim-treesitter-context" },
}
