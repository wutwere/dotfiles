local KEYMAPS = {}

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------
-- GENERAL --
-------------

KEYMAPS.general = function()
	-- editor
	vim.keymap.set("n", "<esc>", "<cmd>noh<cr>")

	vim.keymap.set({ "n", "x" }, "j", "gj", { noremap = true })
	vim.keymap.set({ "n", "x" }, "k", "gk", { noremap = true })

	vim.keymap.set("i", "{<cr>", "{<cr>}<esc>O")
	vim.keymap.set("i", "{<s-cr>", "{<cr>}<esc>O")

	-- delay isn't as bad in WSL if i sync clipboard like this
	vim.keymap.set({ "n", "v" }, "y", '"+y', { silent = true, noremap = true })
	vim.keymap.set({ "n", "v" }, "p", '"+p', { silent = true, noremap = true })
	vim.keymap.set({ "n", "v" }, "d", '"+d', { silent = true, noremap = true })
	vim.keymap.set({ "n", "v" }, "c", '"+c', { silent = true, noremap = true })
	vim.keymap.set({ "n", "v" }, "x", '"+x', { silent = true, noremap = true })
	vim.keymap.set({ "n", "v" }, "Y", '"+Y', { silent = true, noremap = true })
	vim.keymap.set({ "n", "v" }, "P", '"+P', { silent = true, noremap = true })
	vim.keymap.set({ "n", "v" }, "D", '"+D', { silent = true, noremap = true })
	vim.keymap.set({ "n", "v" }, "C", '"+C', { silent = true, noremap = true })
	vim.keymap.set({ "n", "v" }, "X", '"+X', { silent = true, noremap = true })
	vim.keymap.set("n", "<leader>y", function()
		local path = vim.fn.expand("%:p")
		if path ~= "" then
			-- local home = vim.fn.expand("$HOME")
			-- if path:sub(1, #home) == home then
			-- 	path = "~" .. path:sub(#home + 1)
			-- end
			vim.fn.setreg("+", path)
			require("snacks").notify.notify("Copied file path to clipboard.")
		else
			require("snacks").notify.error("No file path found.")
		end
	end, { desc = "Copy file path to clipboard" })

	vim.keymap.set(
		"x",
		"<c-r>",
		'"hy:%s#\\V<c-r>h##gc<left><left><left>',
		{ desc = "Replace all occurrences of selection" }
	)

	local virtual_lines_enabled = true
	local function toggle_virtual_lines()
		if not virtual_lines_enabled then
			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = {
					format = function(diagnostic)
						return ("%s: %s [%s]"):format(diagnostic.source, diagnostic.message, tostring(diagnostic.code))
					end,
				},
			})
		else
			local signs = {
				ERROR = "",
				WARN = "",
				HINT = "󰌵",
				INFO = "",
			}
			vim.diagnostic.config({
				virtual_text = {
					prefix = function(diagnostic)
						return signs[vim.diagnostic.severity[diagnostic.severity]]
					end,
					spacing = 2,
				},
				virtual_lines = false,
			})
		end
		virtual_lines_enabled = not virtual_lines_enabled
	end
	vim.keymap.set("n", "<leader>D", toggle_virtual_lines, { desc = "Toggle diagnostic virtual_lines" })
	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
	toggle_virtual_lines()

	-- competitive programming
	vim.keymap.set("n", "<leader>t", function()
		vim.cmd("update")
		vim.cmd("vsplit +term\\ ./run\\ " .. vim.fn.expand("%:t:r"))
		vim.cmd("startinsert!")
	end, { desc = "Run program in terminal split" })
	vim.keymap.set("t", "<esc>", "<cmd>bd!<cr>")
	vim.keymap.set("t", "<c-n>", "<c-\\><c-n>")

	-- fast navigation
	vim.keymap.set("n", "<c-h>", "20zh")
	vim.keymap.set("n", "<c-l>", "20zl")
	vim.keymap.set("n", "<leader>h", "<c-w>h", { desc = "Move to left pane" })
	vim.keymap.set("n", "<leader>j", "<c-w>j", { desc = "Move to lower pane" })
	vim.keymap.set("n", "<leader>k", "<c-w>k", { desc = "Move to upper pane" })
	vim.keymap.set("n", "<leader>l", "<c-w>l", { desc = "Move to right pane" })
	vim.keymap.set("n", "gb", "<cmd>b#<cr>", { desc = "Go to alt buffer" })
	vim.keymap.set("n", "<bs>", "<cmd>bd<cr>")

	-- plugins
	vim.keymap.set("n", "<leader>r", "<cmd>GrugFar<cr>", { desc = "Search and replace all files" })

	vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>")
	vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>")
	vim.keymap.set("n", "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<cr>")

	vim.keymap.set("n", "<leader>gco", "<Plug>(git-conflict-ours)", { desc = "Merge choose ours" })
	vim.keymap.set("n", "<leader>gct", "<Plug>(git-conflict-theirs)", { desc = "Merge choose theirs" })
	vim.keymap.set("n", "<leader>gcb", "<Plug>(git-conflict-both)", { desc = "Merge choose both" })
	vim.keymap.set("n", "<leader>gc0", "<Plug>(git-conflict-none)", { desc = "Merge choose none" })
	vim.keymap.set("n", "<leader>gcc", function()
		vim.cmd("GitConflictRefresh")
		vim.cmd("GitConflictListQf")
	end, { desc = "Refresh and show conflicts" })

	vim.keymap.set("n", "<leader>n", "<cmd>Namu symbols<cr>", { desc = "Open LSP search" })
end

--------------------------------
-- MINI.FILES / FILE EXPLORER --
--------------------------------

KEYMAPS.mini_files = function()
	local mini_files = require("mini.files")
	mini_files.config.mappings.close = "<esc>"
	mini_files.config.mappings.synchronize = "<cr>"
	mini_files.config.mappings.go_in = "L"
	mini_files.config.mappings.go_in_plus = "l"
	vim.keymap.set("n", "-", function()
		if mini_files.get_explorer_state() == nil then
			mini_files.open(vim.api.nvim_buf_get_name(0))
		end
	end, { desc = "Open file explorer in current file" })
	vim.keymap.set("n", "<leader>-", function()
		mini_files.open()
	end, { desc = "Open file explorer in current working directory" })
end

---------
-- LSP --
---------

KEYMAPS.lsp = function(event)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Show LSP hover at cursor" })
	vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = event.buf, desc = "Go to signature help" })
	vim.keymap.set("n", "<leader>2", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename reference" })
	vim.keymap.set({ "n", "x" }, "<leader>3", vim.lsp.buf.format, { buffer = event.buf, desc = "Format file" })
	vim.keymap.set("n", "<leader>4", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Show code actions" })
end

-----------------
-- MULTICURSOR --
-----------------

KEYMAPS.multicursor = function(mc)
	vim.keymap.set({ "n", "x" }, "<up>", function()
		mc.lineAddCursor(-1)
	end, { desc = "Multicursor - Add cursor above" })
	vim.keymap.set({ "n", "x" }, "<down>", function()
		mc.lineAddCursor(1)
	end, { desc = "Multicursor - Add cursor below" })
	vim.keymap.set({ "n", "x" }, "<leader><up>", function()
		mc.lineSkipCursor(-1)
	end, { desc = "Multicursor - Skip cursor above" })
	vim.keymap.set({ "n", "x" }, "<leader><down>", function()
		mc.lineSkipCursor(1)
	end, { desc = "Multicursor - Skip cursor below" })
	-- Add and remove cursors with control + left click.
	vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
	vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
	vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)
	vim.keymap.set({ "n", "x" }, "!", mc.toggleCursor, { desc = "Multicursor - Add/delete cursor" })
	vim.keymap.set("x", "<leader>ms", mc.splitCursors, { desc = "Multicursor - Split selection by regex" })
	vim.keymap.set("x", "<leader>mf", mc.matchCursors, { desc = "Multicursor - Match selection by regex" })
	vim.keymap.set(
		{ "n", "x" },
		"<leader>ma",
		mc.matchAllAddCursors,
		{ desc = "Multicursor - Add cursor at every word/selection" }
	)
	vim.keymap.set({ "n", "x" }, "<leader>mx", mc.deleteCursor, { desc = "Multicursor - Delete cursor" })
	vim.keymap.set({ "n", "x" }, "<leader>mn", function()
		mc.matchAddCursor(1)
	end, { desc = "Multicursor - Add next word/selection" })
	vim.keymap.set({ "n", "x" }, "<leader>mN", function()
		mc.matchAddCursor(-1)
	end, { desc = "Multicursor - Add previous word/selection" })
	-- vim.keymap.set("x", "I", mc.insertVisual)
	-- vim.keymap.set("x", "A", mc.appendVisual)
	-- Mappings defined in a keymap layer only apply when there are
	-- multiple cursors. This lets you have overlapping mappings.
	mc.addKeymapLayer(function(layerSet)
		-- Select a different cursor as the main one.
		layerSet({ "n", "x" }, "[m", mc.prevCursor)
		layerSet({ "n", "x" }, "]m", mc.nextCursor)
		-- Enable and clear cursors using escape.
		layerSet("n", "<esc>", function()
			if not mc.cursorsEnabled() then
				mc.enableCursors()
			else
				mc.clearCursors()
			end
		end)
	end)
end

--------------------
-- AUTOCOMPLETION --
--------------------

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
				return cmp.show()
			elseif cmp.is_visible() then
				return cmp.select_next()
			end
			return nil
		end,
		"fallback",
	},
	["<S-tab>"] = { "show", "select_prev", "fallback" },
	["<C-j>"] = { "scroll_documentation_down" },
	["<C-k>"] = { "scroll_documentation_up" },
}

KEYMAPS.ai = {
	accept_suggestion = "<right>",
}

------------------------------
-- SNACKS / QUALITY OF LIFE --
------------------------------

local function func_wrap(func, opts)
	return function()
		func(opts)
	end
end

KEYMAPS.snacks = function()
	local Snacks = require("snacks")
	-- Top Pickers & Explorer
	vim.keymap.set(
		"n",
		"<leader>f",
		func_wrap(Snacks.picker.smart, { multi = { "buffers", "files" } }),
		{ desc = "Smart Find Files" }
	)
	vim.keymap.set("n", "<leader>e", func_wrap(Snacks.picker.explorer, { hidden = true }), { desc = "File Tree" })
	vim.keymap.set("n", "<leader>/", func_wrap(Snacks.picker.grep, { hidden = true }), { desc = "Grep" })
	vim.keymap.set("n", "<leader>:", Snacks.picker.command_history, { desc = "Command History" })
	-- git
	vim.keymap.set({ "n", "v" }, "<leader>gB", func_wrap(Snacks.gitbrowse, nil), { desc = "Git Browse" })
	vim.keymap.set("n", "<leader>gg", func_wrap(Snacks.lazygit, nil), { desc = "Lazygit" })
	vim.keymap.set("n", "<leader>gb", Snacks.picker.git_branches, { desc = "Git Branches" })
	vim.keymap.set("n", "<leader>gl", Snacks.picker.git_log, { desc = "Git Log" })
	vim.keymap.set("n", "<leader>gL", Snacks.picker.git_log_line, { desc = "Git Log Line" })
	vim.keymap.set("n", "<leader>gf", Snacks.picker.git_log_file, { desc = "Git Log File" })
	-- Grep
	vim.keymap.set(
		"n",
		"<leader>sB",
		func_wrap(Snacks.picker.grep_buffers, { hidden = true }),
		{ desc = "Grep Open Buffers" }
	)
	vim.keymap.set(
		{ "n", "x" },
		"<leader>sw",
		func_wrap(Snacks.picker.grep_word, { hidden = true }),
		{ desc = "Visual selection or word" }
	)
	-- search
	vim.keymap.set("n", '<leader>s"', Snacks.picker.registers, { desc = "Registers" })
	vim.keymap.set("n", "<leader>s/", Snacks.picker.lines, { desc = "Buffer Lines" })
	vim.keymap.set("n", "<leader>sb", Snacks.picker.buffers, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>sd", Snacks.picker.diagnostics, { desc = "Diagnostics" })
	vim.keymap.set("n", "<leader>sD", Snacks.picker.diagnostics_buffer, { desc = "Buffer Diagnostics" })
	vim.keymap.set("n", "<leader>sh", Snacks.picker.help, { desc = "Help Pages" })
	vim.keymap.set("n", "<leader>si", Snacks.picker.icons, { desc = "Nerd Font Icons" })
	vim.keymap.set("n", "<leader>sj", Snacks.picker.jumps, { desc = "Jumps" })
	vim.keymap.set("n", "<leader>sq", Snacks.picker.qflist, { desc = "Quickfix List" })
	vim.keymap.set("n", "<leader>sR", Snacks.picker.resume, { desc = "Resume" })
	vim.keymap.set("n", "<leader>su", Snacks.picker.undo, { desc = "Undo History" })
	vim.keymap.set("n", "<leader>sm", Snacks.picker.marks, { desc = "Marks" })
	vim.keymap.set("n", "<leader>sp", Snacks.picker.spelling, { desc = "Spelling Suggestions" })
	vim.keymap.set("n", "<leader>sn", Snacks.notifier.show_history, { desc = "Notification History" })
	vim.keymap.set("n", "<leader>ss", func_wrap(Snacks.picker, nil), { desc = "All Snacks Pickers" })
	-- LSP
	vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { desc = "Goto Definition" })
	vim.keymap.set("n", "gD", Snacks.picker.lsp_declarations, { desc = "Goto Declaration" })
	vim.keymap.set("n", "gr", Snacks.picker.lsp_references, { desc = "References" })
	vim.keymap.set("n", "gi", Snacks.picker.lsp_implementations, { desc = "Goto Implementation" })
	vim.keymap.set("n", "go", Snacks.picker.lsp_type_definitions, { desc = "Goto Type Definition" })
	-- Other
	vim.keymap.set("n", "<leader>.", func_wrap(Snacks.scratch, nil), { desc = "Toggle Scratch Buffer" })
	vim.keymap.set("n", "<leader>S", Snacks.scratch.select, { desc = "Select Scratch Buffer" })
	vim.keymap.set("n", "<leader>z", Snacks.zen.zen, { desc = "Enable Zen Mode" })

	-- Custom pick + edit directory
	local function get_directories()
		local directories = {}

		local handle = io.popen("fd . -H --type directory --exclude .git")
		if handle then
			for line in handle:lines() do
				table.insert(directories, line)
			end
			handle:close()
		else
			print("Failed to execute fd command")
		end

		return directories
	end

	vim.keymap.set("n", "<leader><leader>", function()
		local dirs = get_directories()

		return Snacks.picker({
			title = "Directories",
			finder = function()
				local items = {}
				for i, item in ipairs(dirs) do
					table.insert(items, {
						idx = i,
						file = item,
						text = item,
					})
				end
				return items
			end,
			format = function(item, _)
				local file = item.file
				local ret = {}
				local a = Snacks.picker.util.align
				local icon, icon_hl = Snacks.util.icon(file.ft, "directory")
				ret[#ret + 1] = { a(icon, 3), icon_hl }
				ret[#ret + 1] = { " " }
				ret[#ret + 1] = { a(file, 20) }

				return ret
			end,
			confirm = function(picker, item)
				picker:close()
				if item then
					vim.cmd("e " .. item.file)
				end
			end,
		})
	end, { desc = "Directories" })
end

return KEYMAPS
