return {
  'lewis6991/gitsigns.nvim',
  config = function()
	require('gitsigns').setup {
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
		local gs = package.loaded.gitsigns
		local opts = { buffer = bufnr, noremap = true, silent = true }

		vim.keymap.set('n', ']g', gs.next_hunk, opts)
		vim.keymap.set('n', '[g', gs.prev_hunk, opts)
		vim.keymap.set('n', '<leader>gr', gs.reset_hunk, opts)
		vim.keymap.set('n', '<leader>gR', gs.reset_buffer, opts)
		vim.keymap.set('n', '<leader>gt', gs.toggle_current_line_blame, opts)
	  end
	}
  end
}
