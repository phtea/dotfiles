return {
	'tzachar/local-highlight.nvim',
	config = function()
		require('local-highlight').setup({
			debounce_timeout = 0,
			animate = {
				enabled = false,
			},
		})
	end
}
