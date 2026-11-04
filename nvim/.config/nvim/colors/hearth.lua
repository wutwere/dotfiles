-- Transparent colorscheme built from the active ghostty theme.
-- Reads `theme = ...` from the ghostty config, then that theme's palette file.

local FALLBACK = { -- Forge Ember
	bg = "#140c07",
	fg = "#f4e2c8",
	cursor = "#ff6a1f",
	sel = "#33220f",
	-- stylua: ignore
	c = {
		[0] = "#241810", "#ff4733", "#c4c24a", "#ffb347", "#f0a24f", "#ff6a4d", "#ffd27a", "#e6d2b6",
		"#7a6248", "#ff4733", "#c4c24a", "#ff7a2d", "#f0a24f", "#ff6a4d", "#ffd27a", "#f4e2c8",
	},
}

local function read_lines(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local lines = vim.split(f:read("*a"), "\n")
	f:close()
	return lines
end

local function ghostty_palette()
	local dir = (vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config") .. "/ghostty"
	local theme
	for _, line in ipairs(read_lines(dir .. "/config") or {}) do
		theme = line:match("^%s*theme%s*=%s*(.-)%s*$") or theme
	end
	if not theme then
		return nil
	end
	theme = theme:match("dark:([^,]+)") or theme -- `theme = light:X,dark:Y`

	local lines = read_lines(dir .. "/themes/" .. vim.trim(theme))
	if not lines then
		return nil
	end
	local p = { c = {} }
	for _, line in ipairs(lines) do
		local key, val = line:match("^%s*([%w-]+)%s*=%s*(.-)%s*$")
		if key == "palette" then
			local i, hex = val:match("^(%d+)=(#%x+)$")
			if i then
				p.c[tonumber(i)] = hex
			end
		elseif key == "background" then
			p.bg = val
		elseif key == "foreground" then
			p.fg = val
		elseif key == "cursor-color" then
			p.cursor = val
		elseif key == "selection-background" then
			p.sel = val
		end
	end
	for i = 0, 15 do
		if not p.c[i] then
			return nil
		end
	end
	p.bg, p.fg = p.bg or FALLBACK.bg, p.fg or p.c[15]
	p.cursor, p.sel = p.cursor or p.c[3], p.sel or p.c[0]
	return p
end

local p = ghostty_palette() or FALLBACK

local function rgb(hex)
	return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

-- Mix `a` into `b`; t = 1 is all `a`.
local function blend(a, b, t)
	local ar, ag, ab = rgb(a)
	local br, bg, bb = rgb(b)
	local function mix(x, y)
		return math.floor(x * t + y * (1 - t) + 0.5)
	end
	return string.format("#%02x%02x%02x", mix(ar, br), mix(ag, bg), mix(ab, bb))
end

local bg, fg, c = p.bg, p.fg, p.c
local red, green, yellow, blue, magenta, cyan, white = c[1], c[2], c[3], c[4], c[5], c[6], c[7]
local gray, orange, bright = c[8], c[11], c[15]

local surface = blend(fg, bg, 0.06)
local faint = blend(gray, bg, 0.55)
local punct = blend(fg, bg, 0.55)

-- stylua: ignore
local groups = {
	-- editor
	Normal = { fg = fg },
	NormalNC = {},
	NormalFloat = { fg = fg },
	FloatBorder = { fg = gray },
	FloatTitle = { fg = yellow, bold = true },
	Cursor = { fg = bg, bg = p.cursor },
	lCursor = { link = "Cursor" },
	TermCursor = { link = "Cursor" },
	CursorLine = { bg = surface },
	CursorColumn = { bg = surface },
	CursorTab = { bg = blend(fg, bg, 0.1) },
	ColorColumn = {},
	LineNr = { fg = faint },
	CursorLineNr = { fg = bright, bold = true },
	CursorLineSign = { fg = bright, bold = true },
	SignColumn = {},
	FoldColumn = { fg = gray },
	Folded = { fg = gray, bg = surface },
	NonText = { fg = faint },
	Whitespace = { fg = faint },
	EndOfBuffer = { fg = faint },
	SpecialKey = { fg = faint },
	Visual = { bg = p.sel },
	VisualNOS = { bg = p.sel },
	Search = { fg = bright, bg = blend(yellow, bg, 0.3) },
	IncSearch = { fg = bg, bg = yellow, bold = true },
	CurSearch = { link = "IncSearch" },
	Substitute = { fg = bg, bg = red },
	MatchParen = { fg = yellow, bold = true, underline = true },
	Pmenu = { fg = fg },
	PmenuSel = { bg = p.sel, bold = true },
	PmenuSbar = { bg = surface },
	PmenuThumb = { bg = faint },
	PmenuKind = { fg = blue },
	PmenuExtra = { fg = gray },
	PmenuMatch = { fg = yellow, bold = true },
	WildMenu = { link = "PmenuSel" },
	WinSeparator = { fg = faint },
	StatusLine = { fg = blend(yellow, bg, 0.5) }, -- active window rule
	StatusLineNC = { fg = faint },
	TabLine = { fg = gray },
	TabLineSel = { fg = bright, bold = true },
	TabLineFill = {},
	WinBar = { fg = gray },
	WinBarNC = { fg = faint },
	Title = { fg = yellow, bold = true },
	Directory = { fg = blue },
	Question = { fg = green },
	MoreMsg = { fg = green },
	ModeMsg = { fg = fg, bold = true },
	ErrorMsg = { fg = red },
	WarningMsg = { fg = yellow },
	Conceal = { fg = gray },
	QuickFixLine = { bg = p.sel },
	SpellBad = { undercurl = true, sp = red },
	SpellCap = {},
	SpellLocal = {},
	SpellRare = {},

	-- diff / git
	Added = { fg = green },
	Changed = { fg = yellow },
	Removed = { fg = red },
	DiffAdd = { bg = blend(green, bg, 0.16) },
	DiffChange = { bg = blend(blue, bg, 0.12) },
	DiffDelete = { fg = blend(red, bg, 0.5), bg = blend(red, bg, 0.12) },
	DiffText = { bg = blend(blue, bg, 0.3) },

	-- diagnostics
	DiagnosticError = { fg = red },
	DiagnosticWarn = { fg = yellow },
	DiagnosticInfo = { fg = cyan },
	DiagnosticHint = { fg = green },
	DiagnosticOk = { fg = green },
	DiagnosticVirtualTextError = { fg = red, bg = blend(red, bg, 0.12) },
	DiagnosticVirtualTextWarn = { fg = yellow, bg = blend(yellow, bg, 0.1) },
	DiagnosticVirtualTextInfo = { fg = cyan, bg = blend(cyan, bg, 0.1) },
	DiagnosticVirtualTextHint = { fg = green, bg = blend(green, bg, 0.1) },
	DiagnosticUnderlineError = { undercurl = true, sp = red },
	DiagnosticUnderlineWarn = { undercurl = true, sp = yellow },
	DiagnosticUnderlineInfo = { undercurl = true, sp = cyan },
	DiagnosticUnderlineHint = { undercurl = true, sp = green },
	DiagnosticUnnecessary = { fg = gray },
	DiagnosticDeprecated = { strikethrough = true },
	LspReferenceText = { bg = blend(fg, bg, 0.1) },
	LspReferenceRead = { bg = blend(fg, bg, 0.1) },
	LspReferenceWrite = { bg = blend(fg, bg, 0.14) },
	LspInlayHint = { fg = blend(gray, bg, 0.8), italic = true },
	LspSignatureActiveParameter = { fg = yellow, bold = true },

	-- syntax
	Comment = { fg = gray, italic = true },
	Constant = { fg = orange },
	String = { fg = green },
	Character = { fg = green },
	Number = { fg = orange },
	Boolean = { fg = orange, bold = true },
	Float = { fg = orange },
	Identifier = { fg = fg },
	Function = { fg = yellow },
	Statement = { fg = magenta, bold = true },
	Keyword = { fg = magenta, bold = true },
	Operator = { fg = blend(fg, bg, 0.75) },
	PreProc = { fg = magenta },
	Type = { fg = cyan, italic = true, bold = true },
	Special = { fg = blue },
	SpecialChar = { fg = blue },
	Tag = { fg = magenta },
	Delimiter = { fg = punct },
	SpecialComment = { fg = gray, bold = true },
	Debug = { fg = red },
	Underlined = { underline = true },
	Error = { fg = red },
	Todo = { fg = bg, bg = yellow, bold = true },

	-- treesitter
	["@variable"] = { fg = fg },
	["@variable.builtin"] = { fg = blue, italic = true },
	["@variable.parameter"] = { fg = white },
	["@variable.member"] = { fg = white },
	["@property"] = { fg = white },
	["@constant.builtin"] = { fg = orange, italic = true },
	["@module"] = { fg = cyan },
	["@function.builtin"] = { fg = yellow, italic = true },
	["@function.macro"] = { fg = magenta },
	["@constructor"] = { fg = cyan },
	["@keyword.return"] = { fg = red, bold = true },
	["@keyword.operator"] = { fg = magenta, bold = true },
	["@punctuation.special"] = { fg = blue },
	["@string.escape"] = { fg = blue },
	["@string.regexp"] = { fg = blue },
	["@string.special.url"] = { fg = cyan, underline = true },
	["@tag.attribute"] = { fg = yellow, italic = true },
	["@tag.delimiter"] = { fg = punct },
	["@comment.todo"] = { fg = bg, bg = yellow, bold = true },
	["@comment.note"] = { fg = bg, bg = cyan, bold = true },
	["@comment.warning"] = { fg = bg, bg = orange, bold = true },
	["@comment.error"] = { fg = bg, bg = red, bold = true },
	["@markup.heading"] = { fg = yellow, bold = true },
	["@markup.italic"] = { italic = true },
	["@markup.strong"] = { bold = true },
	["@markup.strikethrough"] = { strikethrough = true },
	["@markup.link.url"] = { fg = cyan, underline = true },
	["@markup.link.label"] = { fg = blue },
	["@markup.raw"] = { fg = green },
	["@markup.quote"] = { fg = gray, italic = true },
	["@markup.list"] = { fg = magenta },
	["@diff.plus"] = { link = "Added" },
	["@diff.minus"] = { link = "Removed" },
	["@diff.delta"] = { link = "Changed" },
	["@lsp.mod.deprecated"] = { strikethrough = true },

	-- plugins
	GitSignsAdd = { link = "Added" },
	GitSignsChange = { link = "Changed" },
	GitSignsDelete = { link = "Removed" },
	GitConflictCurrent = { bg = blend(green, bg, 0.14) },
	GitConflictCurrentLabel = { bg = blend(green, bg, 0.3) },
	GitConflictIncoming = { bg = blend(blue, bg, 0.14) },
	GitConflictIncomingLabel = { bg = blend(blue, bg, 0.3) },
	GitConflictAncestor = { bg = blend(gray, bg, 0.2) },
	GitConflictAncestorLabel = { bg = blend(gray, bg, 0.4) },
	BlinkCmpMenu = {},
	BlinkCmpMenuBorder = { link = "FloatBorder" },
	BlinkCmpMenuSelection = { link = "PmenuSel" },
	BlinkCmpDoc = {},
	BlinkCmpDocBorder = { link = "FloatBorder" },
	BlinkCmpDocSeparator = { fg = faint },
	BlinkCmpLabel = { fg = blend(fg, bg, 0.65) },
	BlinkCmpLabelMatch = { fg = bright, bold = true },
	BlinkCmpKind = { fg = blue },
	BlinkCmpGhostText = { fg = gray, italic = true },
	SnacksIndent = { fg = blend(fg, bg, 0.07) },
	SnacksIndentScope = { fg = faint },
	SnacksPickerMatch = { link = "Search" },
	SnacksPickerDir = { fg = gray },
	LazyNormal = {},
	MasonNormal = {},
	WhichKey = { fg = yellow },
	WhichKeyGroup = { fg = blue },
	WhichKeyDesc = { fg = fg },
	WhichKeySeparator = { fg = gray },
	WhichKeyNormal = {},
	FidgetTitle = { fg = yellow },
	FidgetTask = { fg = gray },
	MiniMapNormal = { fg = blend(fg, bg, 0.4) },
	MiniMapSymbolView = { fg = blend(yellow, bg, 0.5) },
	MiniMapSymbolLine = { fg = yellow, bold = true },
	MiniMapSymbolCount = { fg = blue },
	StatusColumnBar = { fg = faint },
	MiniFilesNormal = { link = "NormalFloat" },
	MiniFilesBorder = { link = "FloatBorder" },
	MiniFilesTitleFocused = { fg = yellow, bold = true },
	SnippetTabstop = {},
}

local heading_colors = { yellow, blue, magenta, green, cyan, gray }
for i, col in ipairs(heading_colors) do
	groups["@markup.heading." .. i .. ".markdown"] = { fg = col, bold = true }
	groups["RenderMarkdownH" .. i .. "Bg"] = { bg = blend(col, bg, 0.14) }
	groups["RenderMarkdownH" .. i] = { fg = col, bold = true }
end

vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "hearth"

for name, spec in pairs(groups) do
	vim.api.nvim_set_hl(0, name, spec)
end
for i = 0, 15 do
	vim.g["terminal_color_" .. i] = c[i]
end
