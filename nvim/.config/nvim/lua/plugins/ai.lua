local KEYMAPS = require("config.keymaps")

return {
	-- {
	-- 	"wutwere/supermaven-nvim",
	-- 	opts = {
	-- 		keymaps = KEYMAPS.ai,
	-- 		condition = function()
	-- 			-- disable if file is too big
	-- 			local max_filesize = 1024 * 1024
	-- 			local ok, size = pcall(vim.fn.getfsize, vim.api.nvim_buf_get_name(0))
	-- 			return ok and (size == -2 or size > max_filesize)
	-- 		end,
	-- 	},
	-- },
	-- {
	-- 	"github/copilot.vim",
	-- 	config = function()
	-- 		vim.keymap.set("i", KEYMAPS.ai.accept_suggestion, 'copilot#Accept("\\<CR>")', {
	-- 			expr = true,
	-- 			replace_keycodes = false,
	-- 		})
	-- 		vim.g.copilot_no_tab_map = true
	-- 	end,
	-- },
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				auto_trigger = true,
			},
			copilot_node_command = "node",
			server_opts_overrides = {
				settings = {
					advanced = {
						inlineSuggestCount = 1,
					},
				},
			},
		},
		init = function()
			vim.keymap.set({ "n", "i" }, KEYMAPS.ai.accept_suggestion, function()
				if require("copilot.suggestion").is_visible() then
					require("copilot.suggestion").accept()
				end
			end, { expr = true, replace_keycodes = false, desc = "Accept Copilot suggestion" })
		end,
	},
}
