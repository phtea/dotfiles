vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

local function oil_copy_to_clipboard()
	local oil = require("oil")
	-- Get the visual range or current line
	local start_line = vim.fn.getpos("v")[2]
	local end_line = vim.fn.getpos(".")[2]

	if start_line > end_line then start_line, end_line = end_line, start_line end

	local uris = {}
	for i = start_line, end_line do
		local entry = oil.get_cursor_entry()
		-- If in visual mode, we need to get entry by line index
		if i ~= vim.fn.line(".") then
			-- Note: oil.get_entry_on_line is available in newer versions
			entry = oil.get_entry_on_line(0, i)
		end

		if entry then
			local dir = oil.get_current_dir()
			local full_path = dir .. entry.name
			table.insert(uris, "file://" .. full_path)
		end
	end

	if #uris > 0 then
		local data = table.concat(uris, "\n")
		vim.fn.system({ "xclip", "-selection", "clipboard", "-t", "text/uri-list" }, data)
		print("Copied " .. #uris .. " file(s) to clipboard")
	else
		print("No files selected")
	end
	-- Exit visual mode after copying
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	watch_for_changes = true,
	skip_confirm_for_simple_edits = true,
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["-"] = { "actions.parent", mode = "n" },
		["C"] = { callback = oil_copy_to_clipboard, mode = { "n", "v" }, desc = "Copy files to clipboard" },
	},
	buf_options = {
		bufhidden = "",  -- don't hide this buffer
		buflisted = false, -- and yet don't list it (I want to see Oil in the jumplist but not in buflist)
	},
})

vim.keymap.set('n', '-', "<CMD>Oil<CR>", { desc = "Oil: Open parent directory" })
