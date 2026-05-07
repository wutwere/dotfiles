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
		dependencies = {
			{
				"copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
				opts = {
					nes = {
						move_count_threshold = 30,
					},
				},
			},
		},
		opts = {
			suggestion = {
				auto_trigger = true,
			},
			nes = {
				enabled = true,
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
			vim.g.copilot_nes_debounce = 0
			vim.keymap.set({ "n", "i" }, KEYMAPS.ai.accept_suggestion, function()
				local bufnr = vim.api.nvim_get_current_buf()
				local state = vim.b[bufnr].nes_state
				if state then
					-- Try to jump to the start of the suggestion edit.
					-- If already at the start, then apply the pending suggestion and jump to the end of the edit.
					local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
						or (
							require("copilot-lsp.nes").apply_pending_nes()
							and require("copilot-lsp.nes").walk_cursor_end_edit()
						)
					return
				end
				if require("copilot.suggestion").is_visible() then
					require("copilot.suggestion").accept()
				end
			end, { expr = true, replace_keycodes = false, desc = "Accept Copilot suggestion" })
		end,
	},
}
