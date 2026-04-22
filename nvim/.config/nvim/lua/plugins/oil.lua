vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
oil = require("oil")

local function oil_copy()
	local dir = oil.get_current_dir()
	local uris = {}

	local start = vim.fn.line("v")
	local finish = vim.fn.line(".")
	if start > finish then start, finish = finish, start end

	for i = start, finish do
		local entry = oil.get_entry_on_line(0, i)
		if entry then
			local path = dir .. entry.name
			if entry.type == "directory" then
				for _, f in ipairs(vim.fn.glob(path .. "/**/*", true, true)) do
					if vim.fn.isdirectory(f) == 0 then table.insert(uris, "file://" .. f) end
				end
			else
				table.insert(uris, "file://" .. path)
			end
		end
	end

	if #uris > 0 then
		vim.fn.system({ "xclip", "-selection", "clipboard", "-t", "text/uri-list" }, table.concat(uris, "\n"))
		print("Copied " .. #uris .. " files")
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

oil.setup({
	view_options = { show_hidden = true },
	delete_to_trash = true,
	watch_for_changes = true,
	skip_confirm_for_simple_edits = true,
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["cd"] = "actions.tcd",
		["-"] = "actions.parent",
		["C"] = { callback = oil_copy, mode = { "n", "v" } },
	},
	buf_options = { bufhidden = "", buflisted = false },
})

vim.keymap.set('n', '-', "<CMD>Oil<CR>", { desc = "Oil: Open parent directory" })
