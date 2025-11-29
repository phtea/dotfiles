vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })
require('gitsigns').setup({
	update_debounce = 50,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 500,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']g', gitsigns.next_hunk, { desc = "Gitsigns: Next Hunk" })
		map('n', '[g', gitsigns.prev_hunk, { desc = "Gitsigns: Previous Hunk" })

		-- Views
		map('n', '<leader>gh', gitsigns.preview_hunk, { desc = "Gitsigns: Preview Hunk" })
		map('n', '<leader>tg', gitsigns.toggle_current_line_blame, { desc = "Gitsigns: Toggle Current Blame Line" })
		map('n', '<leader>gb', gitsigns.blame_line, { desc = "Gitsigns: Blame Line" })
		map('n', '<leader>gB', gitsigns.blame, { desc = "Gitsigns: Full Blame" })

		-- Changes
		map('n', '<leader>gs', gitsigns.stage_hunk, { desc = "Gitsigns: Stage Hunk" })
		map('n', '<leader>gr', gitsigns.reset_hunk, { desc = "Gitsigns: Reset Hunk" })

		-- Buffer
		map('n', '<leader>gS', gitsigns.stage_buffer, { desc = "Gitsigns: Stage Buffer" })
		map('n', '<leader>gR', gitsigns.reset_buffer, { desc = "Gitsigns: Reset Buffer" })
		map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = "Gitsigns: Undo Stage Hunk" })

		-- Text object
		map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
	end,
	preview_config = {
		border = 'solid',
	},
	signs_staged_enable = false,
})
