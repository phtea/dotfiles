if true then return {} end -- deprecated plugin, changed with native completion

vim.pack.add({ {
	src = 'https://github.com/saghen/blink.cmp',
	version = vim.version.range('^1')
} })

-- My personal setup

require("blink.cmp").setup({
	keymap = {
		preset = 'default',

		['<Tab>'] = {
			function(cmp)
				if cmp.snippet_active() then
					return cmp.accept()
				else
					return cmp.select_and_accept()
				end
			end,
			'snippet_forward',
			'fallback'
		},
		['<S-Tab>'] = { 'snippet_backward', 'fallback' },
	},
	appearance = {
		nerd_font_variant = 'mono',
	},
	signature = {
		enabled = true,
		window = { border = 'single' },
	},
	completion = {
		menu = { border = 'none' },
		documentation = { window = { border = 'single' } },
	},
	cmdline = {
		enabled = false,
		keymap = { preset = 'inherit' },
		completion = {
			menu = {
				auto_show = function(ctx)
					-- if ':command' has more than n symbols (with :) => auto show completions
					return vim.fn.getcmdtype() == ':' -- and #ctx.line >= 3
				end,
			}
		},
	},
})

-- Recipes
-- Emacs behavior

-- local has_words_before = function()
-- 	local col = vim.api.nvim_win_get_cursor(0)[2]
-- 	if col == 0 then
-- 		return false
-- 	end
-- 	local line = vim.api.nvim_get_current_line()
-- 	return line:sub(col, col):match("%s") == nil
-- end
-- require("blink.cmp").setup({
-- 	keymap = {
-- 		preset = 'none',
-- 		['<Tab>'] = {
-- 			function(cmp)
-- 				if has_words_before() then
-- 					vim.schedule(function()
-- 						require('blink.cmp.completion.list').select_next()
-- 					end)
-- 					return true
-- 				end
-- 			end,
-- 			'fallback',
-- 		},
-- 		['<S-Tab>'] = {
-- 			function()
-- 				vim.schedule(function()
-- 					require('blink.cmp.completion.list').select_prev()
-- 				end)
-- 				return true
-- 			end,
-- 			'fallback',
-- 		},
-- 	},
-- 	completion = {
-- 		ghost_text = {
-- 			enabled = false,
-- 			-- Show the ghost text when no item has been selected, defaulting to the first item
-- 			show_without_selection = true,
-- 		},
-- 		menu = { enabled = false },
-- 		list = { selection = { preselect = false }, cycle = { from_top = false } },
-- 	},
-- })
