return {
	'm4xshen/autoclose.nvim',
	config = {
		keys = {
			["("] = { escape = false, close = true, pair = "()" },
			["["] = { escape = false, close = true, pair = "[]" },
			["{"] = { escape = false, close = true, pair = "{}" },

			[">"] = { escape = true, close = false, pair = "<>" },
			[")"] = { escape = true, close = false, pair = "()" },
			["]"] = { escape = true, close = false, pair = "[]" },
			["}"] = { escape = true, close = false, pair = "{}" },

			['"'] = { escape = true, close = true, pair = '""' },
			["'"] = { escape = true, close = true, pair = "''" },
			["`"] = { escape = true, close = true, pair = "``" },
		},
		options = {
			disabled_filetypes = { "text" },
			pair_spaces = false,
			auto_indent = true,
			touch_regex = "[%w(%[{]",
			disable_command_mode = true,
			disable_when_touch = true,
		},
	}
}
