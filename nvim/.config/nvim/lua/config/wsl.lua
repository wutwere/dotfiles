-- WSL-only startup fixes, loaded from init.lua before plugins. Both work around
-- slow PATH handling: WSL appends the Windows dirs (/mnt/c/...), which are slow to
-- read, and libuv is slow to spawn a command by bare name.

-- Clipboard: point Neovim straight at win32yank (installed with scoop) instead of
-- letting it auto-detect, which checks for several tools in every PATH dir and
-- took ~150ms at startup. Falls back to auto-detection if win32yank isn't found.
for dir in (vim.env.PATH or ""):gmatch("[^:]+") do
	local scoop = dir:match("^(.*/scoop)/shims$")
	if scoop then
		local win32yank = scoop .. "/apps/win32yank/current/win32yank.exe"
		if vim.uv.fs_stat(win32yank) then
			local copy, paste = { win32yank, "-i", "--crlf" }, { win32yank, "-o", "--lf" }
			vim.g.clipboard = {
				name = "win32yank",
				copy = { ["+"] = copy, ["*"] = copy },
				paste = { ["+"] = paste, ["*"] = paste },
				cache_enabled = 1,
			}
		end
		break
	end
end

-- Spawning: make vim.system spawn by absolute path. libuv takes ~5.5ms of blocked
-- UI to spawn a bare name ("git") but ~0.2ms for an absolute path ("/usr/bin/git"),
-- and plugins (gitsigns, blink.cmp, LSP, file watchers) spawn dozens of processes
-- this way. jobstart() already resolves the path itself. vim.system can be called
-- from libuv callbacks ("fast" context), so only vim.uv functions are used here.
do
	local uv = vim.uv
	local system = vim.system
	local resolved = {} ---@type table<string, string|false>

	---@param name string
	---@param path string
	---@return string|false
	local function find_executable(name, path)
		for dir in path:gmatch("[^:]+") do
			local file = dir .. "/" .. name
			local stat = uv.fs_stat(file)
			if stat and stat.type ~= "directory" and uv.fs_access(file, "X") then
				return file
			end
		end
		return false
	end

	---@diagnostic disable-next-line: duplicate-set-field
	vim.system = function(cmd, opts, on_exit)
		local name = type(cmd) == "table" and cmd[1]
		-- Leave alone: paths, and calls that run under a different PATH.
		local own_path = opts and (opts.clear_env or (opts.env and opts.env.PATH))
		if type(name) == "string" and not name:find("/", 1, true) and not own_path then
			local path = uv.os_getenv("PATH") or ""
			local key = path .. "\0" .. name
			local exe = resolved[key]
			if exe == nil then
				exe = find_executable(name, path)
				resolved[key] = exe
			end
			if exe then
				cmd = { exe, unpack(cmd, 2) }
			end
		end
		return system(cmd, opts, on_exit)
	end
end
