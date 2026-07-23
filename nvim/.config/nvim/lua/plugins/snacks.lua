local KEYMAPS = require("config.keymaps")

local function expand_node(Tree, node)
	if not node or not node.dir then
		return
	end

	node.open = true
	Tree:expand(node)

	for _, child in pairs(node.children) do
		expand_node(Tree, child)
	end
end

local function expand_path(picker, path)
	local Tree = require("snacks.explorer.tree")
	local Actions = require("snacks.explorer.actions")
	local node = Tree:find(path)

	if not node or not node.dir then
		return
	end

	expand_node(Tree, node)
	Actions.update(picker, {
		target = path ~= picker:cwd() and path or nil,
		refresh = true,
	})
end

local function expand_under_cursor(picker)
	local item = picker:current()
	if item and item.dir then
		expand_path(picker, item.file)
	end
end

local function expand_all(picker)
	expand_path(picker, picker:cwd())
end

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			-- dashboard = { enabled = true },
			-- explorer = { enabled = true },
			indent = { enabled = true, animate = { enabled = false }, scope = { enabled = false } },
			input = {
				enabled = true,
				expand = false,
			},
			image = { enabled = true },
			notifier = {
				enabled = true,
				top_down = true,
				timeout = 3000,
			},
			picker = {
				enabled = true,
				sources = {
					files = {
						hidden = true,
					},
					explorer = {
						-- layout = { layout = { position = "right" } },
						actions = {
							explorer_expand_all = expand_all,
							explorer_expand_under_cursor = expand_under_cursor,
						},
						win = {
							list = {
								keys = {
									["A"] = "explorer_expand_all",
									["L"] = "explorer_expand_under_cursor",
								},
							},
						},
					},
				},
				previewers = {
					diff = {
						builtin = false,
						cmd = { "delta", "--paging=never" },
					},
				},
				icons = {
					files = {
						enabled = true, -- show file icons
						dir = " ",
						dir_open = " ",
					},
					tree = {
						vertical = "│ ",
						middle = "│ ",
						last = "╰╴",
					},
				},
			},
			quickfile = { enabled = true },
			-- scope = { enabled = true },
			-- scroll = { enabled = true },
			statuscolumn = {
				enabled = false,
				left = { "git" },
				right = {},
				folds = { open = true },
			},
			-- words = { enabled = true },
			styles = {
				notification = {
					-- wo = { wrap = true } -- Wrap notifications
				},
			},
			lazygit = {
				win = { width = 0, height = 0 },
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- mini.files lsp rename integration
					vim.api.nvim_create_autocmd("User", {
						pattern = "MiniFilesActionRename",
						callback = function(event)
							Snacks.rename.on_rename_file(event.data.from, event.data.to)
						end,
					})

					KEYMAPS.snacks()
				end,
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = { preset = "helix", delay = 300, win = { border = "rounded" } },
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
