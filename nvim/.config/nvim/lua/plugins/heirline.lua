local FLASH_INTERVAL = 80
local STATUSLINE_BG = "#1f242d"
local LOCATION_FLASH_BG = "#f85149"
local GIT_ICON = ""
local LSP_ICON = ""

local S = vim.diagnostic and vim.diagnostic.severity or { ERROR = 1, WARN = 2, INFO = 3, HINT = 4 }
local DIAGNOSTICS = {
	{ icon = "", severity = S.ERROR, hl = "UserStatuslineDiagError", src = "DiagnosticError" },
	{ icon = "", severity = S.WARN, hl = "UserStatuslineDiagWarn", src = "DiagnosticWarn" },
	{ icon = "", severity = S.INFO, hl = "UserStatuslineDiagInfo", src = "DiagnosticInfo" },
	{ icon = "󰌵", severity = S.HINT, hl = "UserStatuslineDiagHint", src = "DiagnosticHint" },
}

local function set_highlights()
	for _, d in ipairs(DIAGNOSTICS) do
		vim.api.nvim_set_hl(0, d.hl, { fg = vim.api.nvim_get_hl(0, { name = d.src }).fg, bg = STATUSLINE_BG })
	end
	vim.api.nvim_set_hl(0, "UserStatuslineText", { fg = "#ffffff", bg = STATUSLINE_BG })
	vim.api.nvim_set_hl(0, "UserStatuslineModified", { fg = "#ffffff", bg = STATUSLINE_BG, bold = true })
end

local function hl(group, text)
	if text == "" then
		return ""
	end
	return "%#" .. group .. "#" .. text
end

local function ctx()
	local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	return win, vim.api.nvim_win_get_buf(win)
end

local function filename_hl(win, bufnr)
	local has_errors = vim.diagnostic.count(bufnr)[S.ERROR] ~= nil
	if vim.w[win]._heirline_flash then
		return { fg = "#ffffff", bg = LOCATION_FLASH_BG, bold = has_errors }
	end
	if has_errors then
		return { fg = LOCATION_FLASH_BG, bg = STATUSLINE_BG, bold = true }
	end
	return { fg = "#ffffff", bg = STATUSLINE_BG }
end

local function get_diagnostics(bufnr)
	local counts = vim.diagnostic.count(bufnr)
	local parts = {}
	for _, d in ipairs(DIAGNOSTICS) do
		local count = counts[d.severity] or 0
		if count > 0 then
			table.insert(parts, hl(d.hl, d.icon .. " " .. count))
		end
	end
	return table.concat(parts, " ")
end

local function get_lsp_status(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		return ""
	end
	local seen, names = {}, {}
	for _, c in ipairs(clients) do
		if not seen[c.name] then
			seen[c.name] = true
			names[#names + 1] = c.name
		end
	end
	return LSP_ICON .. " " .. table.concat(names, ", ")
end

local function get_branch(bufnr)
	local head = vim.b[bufnr].gitsigns_head
	if not head or head == "" then
		return ""
	end
	return GIT_ICON .. " " .. head
end

local function right_status(bufnr)
	local sep = hl("UserStatuslineText", "  ")
	local parts = vim.tbl_filter(function(s)
		return s ~= ""
	end, {
		get_diagnostics(bufnr),
		hl("UserStatuslineText", get_lsp_status(bufnr)),
	})
	return table.concat(parts, sep)
end

local function flash(buf, win)
	if win == -1 or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).relative ~= "" then
		return
	end
	if vim.bo[buf].buftype ~= "" or vim.bo[buf].filetype == "oil" then
		return
	end

	local token = (vim.w[win]._heirline_flash_token or 0) + 1
	vim.w[win]._heirline_flash = true
	vim.w[win]._heirline_flash_token = token
	vim.cmd.redrawstatus()

	for i = 1, 3 do
		vim.defer_fn(function()
			if not vim.api.nvim_win_is_valid(win) or vim.w[win]._heirline_flash_token ~= token then
				return
			end
			vim.w[win]._heirline_flash = i % 2 == 0
			vim.cmd.redrawstatus()
		end, FLASH_INTERVAL * i)
	end
end

return {
	{
		"rebelot/heirline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			set_highlights()

			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

			vim.api.nvim_create_autocmd("BufWinEnter", {
				callback = function(args)
					flash(args.buf, vim.fn.bufwinid(args.buf))
				end,
			})

			---@diagnostic disable-next-line: missing-fields
			require("heirline").setup({
				statusline = {
					hl = { bg = STATUSLINE_BG },
					{ provider = " " },
					{
						provider = function()
							return hl("UserStatuslineText", get_branch(select(2, ctx())))
						end,
					},
					{ provider = "%=" },
					{
						provider = function()
							local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(select(2, ctx())), ":~:.")
							return filename == "" and "[No Name]" or filename
						end,
						hl = function()
							return filename_hl(ctx())
						end,
					},
					{
						provider = function()
							return vim.bo[select(2, ctx())].modified and hl("UserStatuslineModified", " [+]") or ""
						end,
					},
					{ provider = "%=" },
					{
						provider = function()
							return right_status(select(2, ctx()))
						end,
					},
					{ provider = " " },
				},
				opts = {
					disable_winbar_cb = function(args)
						return vim.api.nvim_win_get_config(args.winid).relative ~= ""
					end,
				},
			})

			vim.opt.laststatus = 3
		end,
	},
}
