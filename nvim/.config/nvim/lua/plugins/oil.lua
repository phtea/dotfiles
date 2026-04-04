vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

local function oil_copy_to_clipboard()
	local oil = require("oil")
	local uris = {}

	local dir = oil.get_current_dir()
	if not dir then return end

	local function process_entry(entry)
		if not entry then return end
		local full_path = dir .. entry.name

		if entry.type == "directory" then
			local files = vim.fn.glob(full_path .. "/**/*", true, true)
			for _, file in ipairs(files) do
				if vim.fn.isdirectory(file) == 0 then
					table.insert(uris, "file://" .. file)
				end
			end
		else
			table.insert(uris, "file://" .. full_path)
		end
	end

	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" then
		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")
		if start_line > end_line then start_line, end_line = end_line, start_line end

		for i = start_line, end_line do
			process_entry(oil.get_entry_on_line(0, i))
		end
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true) -- back to normal mode
	else
		process_entry(oil.get_cursor_entry())
	end

	if #uris > 0 then
		local data = table.concat(uris, "\n")
		vim.fn.system({ "xclip", "-selection", "clipboard", "-t", "text/uri-list" }, data)
		print("Copied " .. #uris .. " file(s) to clipboard")
	else
		print("No files selected")
	end
end

require("oil").setup({
	view_options = { show_hidden = true, },
	watch_for_changes = true,
	skip_confirm_for_simple_edits = true,
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["`"] = "actions.tcd",
		["-"] = { "actions.parent", mode = "n" },
		["C"] = { callback = oil_copy_to_clipboard, mode = { "n", "v" }, desc = "Copy files to clipboard" },
	},
	buf_options = {
		bufhidden = "",  -- don't hide this buffer
		buflisted = false, -- and yet don't list it (I want to see Oil in the jumplist but not in buflist)
	},
})

vim.keymap.set('n', '-', "<CMD>Oil<CR>", { desc = "Oil: Open parent directory" })
