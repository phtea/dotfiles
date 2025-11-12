vim.pack.add({'https://github.com/lewis6991/gitsigns.nvim'})
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

		-- Navigation
		vim.keymap.set('n', ']g', gs.next_hunk, vim.tbl_extend("force", opts, { desc = "Gitsigns: Next Hunk" }))
		vim.keymap.set('n', '[g', gs.prev_hunk, vim.tbl_extend("force", opts, { desc = "Gitsigns: Previous Hunk" }))

		-- Views
		vim.keymap.set('n', '<leader>gh', gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Gitsigns: Preview Hunk" }))
		vim.keymap.set('n', '<leader>gt', gs.toggle_current_line_blame, vim.tbl_extend("force", opts, { desc = "Gitsigns: Toggle Current Blame Line" }))
		vim.keymap.set('n', '<leader>gb', gs.blame_line, vim.tbl_extend("force", opts, { desc = "Gitsigns: Blame Line" }))
		vim.keymap.set('n', '<leader>gB', gs.blame, vim.tbl_extend("force", opts, { desc = "Gitsigns: Full Blame" }))

		-- Changes
		vim.keymap.set('n', '<leader>gs', gs.stage_hunk, vim.tbl_extend("force", opts, { desc = "Gitsigns: Stage Hunk" }))
		vim.keymap.set('n', '<leader>gr', gs.reset_hunk, vim.tbl_extend("force", opts, { desc = "Gitsigns: Reset Hunk" }))

		-- Buffer
		vim.keymap.set('n', '<leader>gS', gs.stage_buffer, vim.tbl_extend("force", opts, { desc = "Gitsigns: Stage Buffer" }))
		vim.keymap.set('n', '<leader>gR', gs.reset_buffer, vim.tbl_extend("force", opts, { desc = "Gitsigns: Reset Buffer" }))
		vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, vim.tbl_extend("force", opts, { desc = "Gitsigns: Undo Stage Hunk" }))
	end
}
