require('gitsigns').setup {
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local opts = { buffer = bufnr, noremap = true, silent = true }

		-- Navigation
		vim.keymap.set('n', '<leader>gn', gs.next_hunk, opts)
		vim.keymap.set('n', '<leader>gp', gs.prev_hunk, opts)

		vim.keymap.set('n', ']g', gs.next_hunk, opts)
		vim.keymap.set('n', '[g', gs.prev_hunk, opts)

		-- Reset hunk
		vim.keymap.set('n', '<leader>gr', gs.reset_hunk, opts)

		-- Preview hunk
		vim.keymap.set('n', '<leader>gh', gs.preview_hunk, opts)

		-- Stage hunk
		vim.keymap.set('n', '<leader>gs', gs.stage_hunk, opts)

		-- Stage buffer WITH confirmation prompt
		vim.keymap.set('n', '<leader>gS', function()
			vim.ui.input({ prompt = 'Stage entire buffer? Type y to confirm: ' }, function(input)
				if input == 'y' then
					gs.stage_buffer()
					vim.notify('Buffer staged!', vim.log.levels.INFO)
				else
					vim.notify('Cancelled staging buffer.', vim.log.levels.WARN)
				end
			end)
		end, opts)
	end
}
