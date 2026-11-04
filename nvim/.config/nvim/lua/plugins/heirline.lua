-- Per-window statusline drawn as a thin rule (fillchars stl/stlnc) with the
-- file's state set into it. Non-file windows get the bare rule.
-- Colors come from highlight groups, so any colorscheme works.

local FLASH_INTERVAL = 80
local LSP_ICON = ""

local S = vim.diagnostic.severity
local DIAGNOSTICS = {
	{ icon = "", severity = S.ERROR, src = "DiagnosticError" },
	{ icon = "", severity = S.WARN, src = "DiagnosticWarn" },
	{ icon = "", severity = S.INFO, src = "DiagnosticInfo" },
	{ icon = "󰌵", severity = S.HINT, src = "DiagnosticHint" },
}

-- Colors resolved from the current colorscheme, refreshed on ColorScheme.
local C = {}
local function refresh_colors()
	local function get(name, attr)
		local v = vim.api.nvim_get_hl(0, { name = name, link = false })[attr or "fg"]
		return v and string.format("#%06x", v)
	end
	C.text = get("Normal")
	C.dim = get("Comment")
	C.modified = get("Changed") or get("DiagnosticWarn")
	C.warn = get("DiagnosticWarn")
	C.error = get("DiagnosticError")
	C.flash_fg = get("IncSearch")
	C.flash_bg = get("IncSearch", "bg")
	for _, d in ipairs(DIAGNOSTICS) do
		C[d.src] = get(d.src)
	end
end

local function ctx()
	local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	return win, vim.api.nvim_win_get_buf(win)
end

local function buf()
	return select(2, ctx())
end

-- While a statusline is drawn, the current window is the one being drawn and
-- g:actual_curwin is the window that really has focus.
local function is_active()
	return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

local function is_file(bufnr)
	return vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= ""
end

local function rule_hl()
	return is_active() and "StatusLine" or "StatusLineNC"
end

local function name_hl()
	local win, bufnr = ctx()
	local has_errors = vim.diagnostic.count(bufnr)[S.ERROR] ~= nil
	if vim.w[win]._heirline_flash then
		return { fg = C.flash_fg, bg = C.flash_bg, bold = true }
	end
	if has_errors then
		return { fg = C.error, bold = true, undercurl = true, sp = C.error }
	end
	if is_active() then
		return { fg = C.text, bold = true }
	end
	return { fg = C.dim }
end

local function flash(bufnr, win)
	if win == -1 or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).relative ~= "" then
		return
	end
	if not is_file(bufnr) then
		return
	end

	local token = (vim.w[win]._heirline_flash_token or 0) + 1
	vim.w[win]._heirline_flash = true
	vim.w[win]._heirline_flash_token = token

	for i = 0, 3 do
		vim.defer_fn(function()
			if not vim.api.nvim_win_is_valid(win) or vim.w[win]._heirline_flash_token ~= token then
				return
			end
			vim.w[win]._heirline_flash = i % 2 == 0
			vim.cmd.redrawstatus()
		end, FLASH_INTERVAL * i)
	end
end

local Rule = { provider = "──", hl = rule_hl }

local Icon = {
	provider = function()
		local icon = require("nvim-web-devicons").get_icon(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf()), ":t"), nil, { default = true })
		return " " .. icon
	end,
	hl = function()
		local _, color = require("nvim-web-devicons").get_icon_color(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf()), ":t"), nil, {
			default = true,
		})
		return { fg = is_active() and color or C.dim }
	end,
}

local Name = {
	provider = function()
		return " " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf()), ":t") .. " "
	end,
	hl = name_hl,
}

local Modified = {
	condition = function()
		return vim.bo[buf()].modified
	end,
	provider = "● ",
	hl = function()
		return { fg = C.modified }
	end,
}

local Readonly = {
	condition = function()
		return vim.bo[buf()].readonly or not vim.bo[buf()].modifiable
	end,
	provider = " ",
	hl = function()
		return { fg = C.dim }
	end,
}

local Path = {
	provider = function()
		local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf()), ":~:.:h")
		return path ~= "." and path .. " " or ""
	end,
	hl = function()
		return { fg = C.dim }
	end,
}

-- Only shown when unusual: CRLF line endings or a non-UTF-8 encoding.
local Format = {
	provider = function()
		local bo = vim.bo[buf()]
		local parts = {}
		if bo.fileformat ~= "unix" then
			parts[#parts + 1] = bo.fileformat
		end
		if bo.fileencoding ~= "" and bo.fileencoding ~= "utf-8" then
			parts[#parts + 1] = bo.fileencoding
		end
		return #parts > 0 and table.concat(parts, " ") .. " " or ""
	end,
	hl = function()
		return { fg = C.warn }
	end,
}

local Diagnostics = {
	init = function(self)
		self.counts = vim.diagnostic.count(buf())
	end,
	condition = function()
		return next(vim.diagnostic.count(buf())) ~= nil
	end,
	{ provider = " " },
	vim.tbl_map(function(d)
		return {
			provider = function(self)
				local n = self.counts[d.severity]
				return n and d.icon .. " " .. n .. " " or ""
			end,
			hl = function()
				return { fg = C[d.src] }
			end,
		}
	end, DIAGNOSTICS),
}

local Lsp = {
	condition = function()
		return is_active() and #vim.lsp.get_clients({ bufnr = buf() }) > 0
	end,
	provider = function()
		local seen, names = {}, {}
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf() })) do
			if not seen[client.name] then
				seen[client.name] = true
				names[#names + 1] = client.name
			end
		end
		return " " .. LSP_ICON .. " " .. table.concat(names, ", ") .. " "
	end,
	hl = function()
		return { fg = C.dim }
	end,
}

local FileStatusline = {
	condition = function()
		return is_file(buf())
	end,
	Rule,
	Icon,
	Name,
	Modified,
	Readonly,
	-- Truncate the path first when the window is narrow.
	{ provider = "%<" },
	Path,
	Format,
	{ provider = "%=", hl = rule_hl },
	Diagnostics,
	Lsp,
	Rule,
}

local BareStatusline = { provider = "%=", hl = rule_hl }

return {
	{
		"rebelot/heirline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			refresh_colors()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = refresh_colors })

			vim.api.nvim_create_autocmd("BufWinEnter", {
				callback = function(args)
					flash(args.buf, vim.fn.bufwinid(args.buf))
				end,
			})

			vim.opt.laststatus = 2
			vim.opt.fillchars:append({ stl = "─", stlnc = "─" })

			require("heirline").setup({
				---@diagnostic disable-next-line: missing-fields
				statusline = { fallthrough = false, FileStatusline, BareStatusline },
			})
		end,
	},
}
