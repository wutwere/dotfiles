-- Line numbers, then a thin neutral bar that takes gitsigns' color on changed
-- lines. Signs are not drawn, so the column never changes width.

local M = {}

local NEUTRAL, CHANGED = "│", "┃"

local function set_default_hl()
	vim.api.nvim_set_hl(0, "StatusColumnBar", { link = "WinSeparator", default = true })
end
set_default_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_default_hl })

local git_ns
local function git_namespaces()
	if not git_ns then
		local all = vim.api.nvim_get_namespaces()
		if all["gitsigns_signs_"] then
			git_ns = { all["gitsigns_signs_"], all["gitsigns_signs_staged"] }
		end
	end
	return git_ns or {}
end

local function git_hl(buf, lnum)
	for _, ns in ipairs(git_namespaces()) do
		local marks = vim.api.nvim_buf_get_extmarks(buf, ns, { lnum - 1, 0 }, { lnum - 1, -1 }, {
			details = true,
			type = "sign",
			limit = 1,
		})
		if marks[1] and marks[1][4].sign_hl_group then
			return marks[1][4].sign_hl_group
		end
	end
end

function M.render()
	local win = vim.g.statusline_winid
	local buf = vim.api.nvim_win_get_buf(win)
	local wo = vim.wo[win]
	local lnum, relnum, virtnum = vim.v.lnum, vim.v.relnum, vim.v.virtnum

	local number = ""
	if (wo.number or wo.relativenumber) and virtnum == 0 then
		if relnum == 0 then
			number = "%#CursorLineNr#" .. (wo.number and lnum or 0)
		else
			number = "%#LineNr#" .. (wo.relativenumber and relnum or lnum)
		end
	end
	local width = math.max(wo.numberwidth - 1, #tostring(vim.api.nvim_buf_line_count(buf)))
	local out = "%" .. width .. "(" .. number .. "%) "

	if vim.bo[buf].buftype ~= "" then
		return out
	end
	local hl = git_hl(buf, lnum)
	return out .. (hl and "%#" .. hl .. "#" .. CHANGED or "%#StatusColumnBar#" .. NEUTRAL) .. "%* "
end

return M
