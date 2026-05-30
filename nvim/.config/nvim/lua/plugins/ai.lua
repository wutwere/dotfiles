local KEYMAPS = require("config.keymaps")

return {
	{
		"zbirenbaum/copilot.lua",
		lazy = true,
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
