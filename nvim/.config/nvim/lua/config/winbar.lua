local M = {}

local DEFAULT_WINBAR = "%{%v:lua.winbar()%}"
local FLASH_INTERVAL = 75
local FLASH_COUNT = 2

vim.api.nvim_set_hl(0, "WinBarFlash", { fg = "#ffffff" })

local function redraw_winbar(winid)
	if vim.api.nvim_win_is_valid(winid) then
		vim.cmd("redrawstatus")
	end
end

local function flash_winbar(winid)
	local state = vim.w[winid]
	local token = (state._winbar_flash_token or 0) + 1

	state._winbar_flash = true
	state._winbar_flash_token = token
	redraw_winbar(winid)

	local function pulse(remaining_toggles)
		vim.defer_fn(function()
			if not vim.api.nvim_win_is_valid(winid) or vim.w[winid]._winbar_flash_token ~= token then
				return
			end

			vim.w[winid]._winbar_flash = not vim.w[winid]._winbar_flash
			redraw_winbar(winid)

			if remaining_toggles > 1 then
				pulse(remaining_toggles - 1)
			end
		end, FLASH_INTERVAL)
	end

	pulse((FLASH_COUNT * 2) - 1)
end

function _G.winbar()
	local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(winid)

	local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
	local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":~:.")

	if file == "" then
		return cwd
	end

	local location = file

	if not file:match("^[~/]") then
		location = cwd .. "/" .. file
	end

	local value = location
	local modified = vim.bo[bufnr].modified and " [+]" or ""

	if vim.w[winid]._winbar_flash then
		return "%#WinBarFlash#" .. value .. "%*" .. modified
	end

	return value .. modified
end

function M.setup()
	vim.api.nvim_create_autocmd("BufWinEnter", {
		callback = function(args)
			local buftype = vim.bo[args.buf].buftype
			local current_winbar = vim.wo.winbar

			flash_winbar(vim.api.nvim_get_current_win())

			if buftype == "" then
				vim.wo.winbar = DEFAULT_WINBAR
			elseif current_winbar == DEFAULT_WINBAR then
				vim.wo.winbar = ""
			end
		end,
	})
end

return M
