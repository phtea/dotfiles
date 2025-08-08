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

		vim.keymap.set('n', ']h', gs.next_hunk, vim.tbl_extend("force", opts, { desc = "Git: Next Hunk" }))
		vim.keymap.set('n', '[h', gs.prev_hunk, vim.tbl_extend("force", opts, { desc = "Git: Previous Hunk" }))
		vim.keymap.set('n', '<leader>gr', gs.reset_hunk, vim.tbl_extend("force", opts, { desc = "Git: Reset Hunk" }))
		vim.keymap.set('n', '<leader>gR', gs.reset_buffer, vim.tbl_extend("force", opts, { desc = "Git: Reset Buffer" }))
		vim.keymap.set('n', '<leader>gt', gs.toggle_current_line_blame, vim.tbl_extend("force", opts, { desc = "Git: Toggle Line Blame" }))
		vim.keymap.set('n', '<leader>gh', gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Git: Preview Hunk" }))
		vim.keymap.set('n', '<C-w>h', gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Git: Preview Hunk" }))
	  end
	}
  end
}
