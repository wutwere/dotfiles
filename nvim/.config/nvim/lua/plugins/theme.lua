return {
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		opts = {
			options = {
				transparent = true,
				styles = {
					comments = "italic",
					keywords = "bold",
					types = "italic,bold",
				},
			},
			groups = {
				all = {
					["@markup.italic"] = { italic = true }, -- for markdown if i decide to disable global italic
					["BlinkCmpDoc"] = { bg = "NONE" },
					["BlinkCmpDocSeparator"] = { bg = "NONE" },
					["BlinkCmpKind"] = { fg = "#FF7B72" },
					["BlinkCmpLabel"] = { fg = "#8B949E" },
					["BlinkCmpLabelMatch"] = { style = "bold", fg = "#FFFFFF" },
					["BlinkCmpMenu"] = { bg = "NONE" },
					["BufferLineFill"] = { bg = "NONE" },
					["ColorColumn"] = { bg = "NONE" }, -- markdown code block
					["Comment"] = { italic = true }, -- for markdown if i decide to disable global italic
					["CursorLine"] = { bg = "#0a0a0c" },
					["CursorLineNr"] = { style = "bold", fg = "#FFFFFF", bg = "#0a0a0c" },
					["CursorLineSign"] = { style = "bold", fg = "#FFFFFF", bg = "#0a0a0c" },
					-- ["Directory"] = { bg = "NONE" }, -- ?
					["DiagnosticVirtualTextHint"] = { bg = "#17191c" },
					["DiagnosticVirtualTextInfo"] = { bg = "#021631" },
					["DiagnosticVirtualTextWarn"] = { bg = "#2c2007" },
					["DiagnosticVirtualTextError"] = { bg = "#310402" },
					["FloatBorder"] = { fg = "#FFFFFF" },
					["LazyNormal"] = { bg = "NONE" },
					["NonText"] = { fg = "#454b54" }, -- line wrap icon
					["Pmenu"] = { bg = "NONE" }, -- for blink cmp
					["PmenuExtra"] = { bg = "NONE" }, -- for blink cmp
					-- ["RenderMarkdownChecked"] = { fg = "#A7E22E" },
					-- ["SignColumn"] = { bg = "NONE" },
					["SnacksIndent"] = { fg = "#161B22" },
					["SnippetTabstop"] = { link = "NONE" }, -- ?
					-- ["SpellBad"] = { link = "NONE" },
					["SpellCap"] = { link = "NONE" },
					["SpellLocal"] = { link = "NONE" },
					["SpellRare"] = { link = "NONE" },
					["StatusLine"] = { bg = "NONE" }, -- default status line, fix weird flash on start
					["TabLineFill"] = { bg = "NONE" }, -- tabline background
					-- ["TreesitterContext"] = { bg = "NONE" },
					-- ["TreesitterContextLineNumber"] = { link = "Keyword" },
					["WinBar"] = { fg = "#4C576D" },
				},
			},
		},
		init = function()
			vim.cmd.colorscheme("github_dark_default")
		end,
	},
}
