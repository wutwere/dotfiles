return {
	{
		"Exafunction/codeium.vim",
		init = function()
			vim.g.codeium_disable_bindings = 1
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
					model = { model = "gemini-2.5-pro-exp-03-25", temperature = 1, top_p = 0.95 },
					system_prompt = [[
You are Gemini. You are a helpful assistant.
Your job is to answer questions as accurately as possible.
You must always make sure your answers are absolutely right.
Use $ for inline math expressions, and $$ for math blocks. This is Markdown.
          ]],
				},
			},
			chat_user_prefix = "---",
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
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				chat = { adapter = "gemini" },
				inline = { adapter = "gemini" },
				cmd = { adapter = "gemini" },
			},
			adapters = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						env = {
							api_key = "cmd:grep GEMINI_API_KEY ~/.env | cut -d'=' -f2",
						},
					})
				end,
				geminipro = function()
					return require("codecompanion.adapters").extend("gemini", {
						env = {
							api_key = "cmd:grep GEMINI_API_KEY ~/.env | cut -d'=' -f2",
						},
						schema = {
							model = {
								default = "gemini-2.5-pro-exp-03-25",
							},
						},
					})
				end,
			},
			display = { chat = { auto_scroll = false } },
		},
	},
}
