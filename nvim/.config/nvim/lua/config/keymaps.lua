local KEYMAPS = {}

vim.g.mapleader = " "
vim.g.maplocalleader = " "

KEYMAPS.general = function()
	-- editor
	vim.keymap.set("i", "{<cr>", "{<cr>}<esc>O")
	vim.keymap.set("i", "{<s-cr>", "{<cr>}<esc>O")
	vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selected to clipboard" })
	vim.keymap.set("n", "<leader>y", "<cmd>%y+<cr>", { desc = "Copy entire file contents to clipboard" })
	vim.keymap.set("n", "<leader>Y", function()
		vim.fn.setreg("+", vim.fn.expand("%:p"))
	end, { desc = "Copy file path to clipboard" })
	vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste clipboard" })
	vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste clipboard" })
	vim.keymap.set("n", "<leader>m", "<cmd>e $MYVIMRC<cr>", { desc = "Edit vim config" })
	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics at cursor" })
	vim.keymap.set("n", "<leader>w", "<cmd>tabc<cr>", { desc = "Close tab" })

	-- competitive programming
	vim.keymap.set("n", "<leader>t", function()
		vim.cmd("update")
		vim.cmd("vsplit +term\\ ./run\\ " .. vim.fn.expand("%:t:r"))
		vim.cmd("startinsert!")
	end, { desc = "Run program in terminal split" })
	vim.keymap.set("t", "<esc>", "<cmd>bd!<cr>")
	vim.keymap.set("t", "<c-n>", "<c-\\><c-n>")

	-- fast navigation
	vim.keymap.set("n", "<c-e>", "7<c-e>")
	vim.keymap.set("n", "<c-y>", "7<c-y>")
	vim.keymap.set("n", "<leader>j", "<c-w>j", { desc = "Move to lower pane" })
	vim.keymap.set("n", "<leader>k", "<c-w>k", { desc = "Move to upper pane" })
	vim.keymap.set("n", "<leader>l", "<c-w>l", { desc = "Move to right pane" })
	vim.keymap.set("n", "gb", "<cmd>b#<cr>")
	vim.keymap.set("n", "]b", "<cmd>bn<cr>")
	vim.keymap.set("n", "[b", "<cmd>bp<cr>")
	vim.keymap.set("n", "]c", "<cmd>cn<cr>")
	vim.keymap.set("n", "[c", "<cmd>cp<cr>")

	-- plugins
	-- vim.keymap.set("n", "<leader><space>", "<cmd>FzfLua files<cr>")
	-- vim.keymap.set({ "n", "v" }, "<leader>ff", "<cmd>FzfLua<cr>")
	-- vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<cr>")
	-- vim.keymap.set("n", "<leader>fj", "<cmd>FzfLua jumps<cr>")
	-- vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
	-- vim.keymap.set("n", "<leader>fz", "<cmd>FzfLua zoxide<cr>")
	-- vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>")
	-- vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua lines<cr>")
	-- vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>")
	-- vim.keymap.set("v", "<leader>fv", "<cmd>FzfLua grep_visual<cr>")

	vim.keymap.set("n", "<leader>r", "<cmd>GrugFar<cr>", { desc = "Search and replace all files" })

	-- vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>")
	vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>")
	-- vim.keymap.set("n", "<leader>gb", "<cmd>Neogit branch<cr>")
	-- vim.keymap.set("n", "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<cr>")
	-- vim.keymap.set("n", "<leader>gL", "<cmd>Gitsigns blame<cr>")
	vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>")
	vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>")

	vim.keymap.set("n", "<leader>n", "<cmd>Namu symbols<cr>", { desc = "Open LSP search" })

	vim.keymap.set("n", "<bs>", "<cmd>NoiceDismiss<cr>")
end

KEYMAPS.mini_files = function(mini_files)
	mini_files.config.mappings.close = "<esc>"
	vim.keymap.set("n", "-", function()
		mini_files.open(vim.fn.expand("%:p:h"), false)
	end, { desc = "Open file explorer" })
	vim.keymap.set("n", "<leader>-", function()
		local state = mini_files.get_explorer_state()
		local dir = state and state.branch[state.depth_focus] or "%:h"
		vim.cmd("cd " .. dir)
		vim.cmd("pwd")
	end, { desc = "Set working directory here" })
end

KEYMAPS.lsp = function(event)
	local opts = { buffer = event.buf }
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Show LSP hover at cursor" })
	-- vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", opts)
	-- vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", opts)
	-- vim.keymap.set("n", "go", "<cmd>FzfLua lsp_type_defs<cr>", opts)
	-- vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opts)
	vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = event.buf, desc = "Go to signature help" })
	vim.keymap.set("n", "<leader>2", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename reference" })
	vim.keymap.set({ "n", "x" }, "<leader>3", vim.lsp.buf.format, { buffer = event.buf, desc = "Format file" })
	vim.keymap.set("n", "<leader>4", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Show code actions" })
end

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

KEYMAPS.cmp = {
	preset = "none",
	["<cr>"] = { "accept", "fallback" },
	["<tab>"] = {
		function(cmp)
			if has_words_before() and not cmp.is_visible() then
				return cmp.show() and cmp.select_next()
			elseif cmp.is_visible() then
				return cmp.select_next()
			end
			return nil
		end,
	},
	["<S-tab>"] = { "show", "select_prev", "fallback" },
	["<C-j>"] = { "scroll_documentation_down" },
	["<C-k>"] = { "scroll_documentation_up" },
}

return KEYMAPS
