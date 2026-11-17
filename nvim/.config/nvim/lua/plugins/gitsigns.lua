require('gitsigns').setup({
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']c', gitsigns.next_hunk, { desc = "Gitsigns: Next Change" })
		map('n', '[c', gitsigns.prev_hunk, { desc = "Gitsigns: Previous Change" })

		-- Views
		map('n', '<leader>gh', gitsigns.preview_hunk, { desc = "Gitsigns: Preview Hunk" })
		map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Gitsigns: Toggle Current Blame Line" })
		map('n', '<leader>ts', gitsigns.toggle_signs, { desc = "Gitsigns: Toggle signs" })
		map('n', '<leader>gb', gitsigns.blame_line, { desc = "Gitsigns: Blame Line" })
		map('n', '<leader>gB', function()
			local filename = vim.fn.expand('%:t')
			print(string.format("Git Blame: %s", filename))
			gitsigns.blame()
		end, { desc = "Gitsigns: Full Blame" })

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
	signs_staged_enable = false,
})
-- The default popup_setpos mouse model moves the cursor to the clicked hunk.
local hunk_menu = {
	{ label = "Preview hunk", action = "preview_hunk" },
	{ label = "Stage / unstage hunk", action = "stage_hunk" },
	{ label = "Reset hunk", action = "reset_hunk" },
	{ label = "Undo last hunk stage", action = "undo_stage_hunk" },
}

pcall(vim.cmd, "nunmenu PopUp.-Gitsigns-")
for index, item in ipairs(hunk_menu) do
	item.path = "PopUp." .. item.label:gsub(" ", "\\ ")
	pcall(vim.cmd, "nunmenu " .. item.path)
	vim.cmd(('nnoremenu 10.%d %s <Cmd>lua require("gitsigns").%s()<CR>'):format(index, item.path, item.action))
	vim.cmd("nmenu disable " .. item.path)
end

vim.cmd([[
	nnoremenu 10.5 PopUp.Show\ all\ changed\ files <Cmd>lua Snacks.picker.git_status({ ignored = false })<CR>
	nnoremenu 10.6 PopUp.Diff\ to\.\.\. :Gitsigns diffthis<Space>
	nnoremenu 10.10 PopUp.-Gitsigns- <Nop>
]])

vim.api.nvim_create_autocmd("MenuPopup", {
	group = vim.api.nvim_create_augroup("GitsignsPopupMenu", { clear = true }),
	pattern = "n",
	callback = function()
		local actions = require('gitsigns').get_actions() or {}
		for _, item in ipairs(hunk_menu) do
			local state = actions[item.action] and "enable" or "disable"
			vim.cmd("nmenu " .. state .. " " .. item.path)
		end
	end,
})
