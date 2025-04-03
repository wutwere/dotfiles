local KEYMAPS = require("config.keymaps")

return {
	{ "ThePrimeagen/vim-be-good" },
	{
		"echasnovski/mini.files",
		config = function()
			local mini_files = require("mini.files")
			mini_files.setup({
				windows = {
					preview = true,
					width_preview = 30,
					width_nofocus = 30,
					width_focus = 30,
				},
			})
			KEYMAPS.mini_files(mini_files)
		end,
	},
	{ "MagicDuck/grug-far.nvim", opts = { windowCreationCommand = "e" } },
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.opt.conceallevel = 1
			vim.g.tex_conceal = "abdmg"
			vim.g.vimtex_view_method = "sioyek"
			vim.g.vimtex_callback_progpath = vim.fn.system("where nvim")
			vim.g.vimtex_quickfix_open_on_warning = 0
		end,
	},
	{ "lewis6991/gitsigns.nvim", opts = { current_line_blame_opts = { delay = 0 } } },
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		opts = { default_mappings = false },
		init = function()
			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				callback = function()
					vim.cmd("GitConflictRefresh")
				end,
			})
		end,
	},
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			KEYMAPS.multicursor(mc)

			-- Customize how cursors look.
			-- local hl = vim.api.nvim_set_hl
			-- hl(0, "MultiCursorCursor", { link = "Cursor" })
			-- hl(0, "MultiCursorVisual", { link = "Visual" })
			-- hl(0, "MultiCursorSign", { link = "SignColumn" })
			-- hl(0, "MultiCursorMatchPreview", { link = "Search" })
			-- hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
			-- hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			-- hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},
	{
		"robitx/gp.nvim",
		opts = {
			cmd_prefix = "AI",
			providers = {
				googleai = {
					disable = false,
					endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
					secret = {
						"bash",
						"-c",
						"grep GEMINI_API_KEY ~/.env | cut -d'=' -f2",
					},
				},
			},
			agents = {
				{
					provider = "googleai",
					name = "gemini-2.0-flash",
					chat = true,
					command = false,
					-- string with model name or table with model name and parameters
					model = { model = "gemini-2.0-flash", temperature = 1, top_p = 0.95 },
					-- system prompt (use this to specify the persona/role of the AI)
					system_prompt = [[
You are Gemini. You are a helpful assistant.
Stay concise and clear in your responses. Explain complicated details simply when needed.
Use $ for inline math expressions, and $$ for math blocks. This is Markdown.
          ]],
				},
				{
					provider = "googleai",
					name = "gemini-2.5-pro-exp-03-25",
					chat = true,
					command = false,
					-- string with model name or table with model name and parameters
					model = { model = "gemini-2.5-pro-exp-03-25", temperature = 1, top_p = 0.95 },
					-- system prompt (use this to specify the persona/role of the AI)
					system_prompt = [[
You are Gemini. You are a helpful assistant.
Your job is to answer questions as accurately as possible.
You must always make sure your answers are absolutely right.
Use $ for inline math expressions, and $$ for math blocks. This is Markdown.
          ]],
				},
			},
			chat_user_prefix = "---",
			-- chat assistant prompt prefix (static string or a table {static, template})
			-- first string has to be static, second string can contain template {{agent}}
			-- just a static string is legacy and the [{{agent}}] element is added automatically
			-- if you really want just a static string, make it a table with one element { "🤖:" }
			chat_assistant_prefix = { "### **", "{{agent}}**" },
			chat_template = [[
# topic: ?
- file: {{filename}}
- type below and <leader>as to submit
- vim:wrap

{{user_prefix}}
]],
			chat_confirm_delete = false,
			chat_free_cursor = true,
			chat_finder_pattern = "# topic: ",
			chat_finder_mappings = {
				delete = { modes = { "n", "v", "x" }, shortcut = "d" },
			},
		},
	},
}
