return {
  'lewis6991/gitsigns.nvim',
  config = function()
	require('gitsigns').setup {
	  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
	  on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local opts = { buffer = bufnr, noremap = true, silent = true }

		vim.keymap.set('n', '<leader>gn', gs.next_hunk, opts)
		vim.keymap.set('n', '<leader>gp', gs.prev_hunk, opts)
		vim.keymap.set('n', ']g', gs.next_hunk, opts)
		vim.keymap.set('n', '[g', gs.prev_hunk, opts)
		vim.keymap.set('n', '<leader>gr', gs.reset_hunk, opts)
		vim.keymap.set('n', '<leader>gh', gs.preview_hunk, opts)
		vim.keymap.set('n', '<leader>gs', gs.stage_hunk, opts)
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
  end
}
