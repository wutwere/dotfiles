local KEYMAPS = require("config.keymaps")

return {
	{
		"wutwere/supermaven-nvim",
		opts = {
			keymaps = KEYMAPS.ai,
			condition = function()
				-- disable if file is too big
				local max_filesize = 1024 * 1024
				local ok, size = pcall(vim.fn.getfsize, vim.api.nvim_buf_get_name(0))
				return ok and (size == -2 or size > max_filesize)
			end,
		},
	},
}
