vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
	lazygit = { win = { backdrop = false, height = 0, width = 0, }, },
	picker = {
		prompt = "",
		hidden = true,
		ignored = true,
		icons = {
			files = { enabled = false, },
			ui = {
				live = "󰐰",
			},
		},
		win = {
			border = "single",
			input = {
				keys = {
					["<Esc>"] = { "close", mode = { "i", "n" } },
					["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
					["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
					["<F1>"] = { "toggle_help_input", mode = { "i", "n" } },
				}
			}
		},
		layout = {
			layout = {
				backdrop = false,
				box = "horizontal",
				width = 0.9,
				min_width = 120,
				height = 0.85,
				{
					box = "vertical",
					border = "single",
					title = "{title} {live} {flags}",
					{ win = "input", height = 1,     border = "bottom" },
					{ win = "list",  border = "none" },
				},
				{ win = "preview", title = "{preview}", border = "single", width = 0.5 },
			},
		}
	},
	bigfile = { enabled = true, notify = false, },
})

-- Basic pickers
vim.keymap.set("n", "<leader><space>", function() Snacks.picker() end, { desc = "Picker of all pickers" })
vim.keymap.set("n", "<leader>f",
	function()
		Snacks.picker.files({
			hidden = true,
			exclude = {
				"*.gz", "*.zip", "*.tar", "*.tgz", "*.xz", "*.so",
				"*.bz2", "*.7z", "*.rar", "*.zst", "*.jar", "*.war",
			},
		})
	end,
	{ desc = "Find files" }
)
vim.keymap.set("n", "<leader>F", function() Snacks.picker.files({ hidden = true, ignored = true, }) end, { desc = "Find files (no ignores)" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep({ ignored = false }) end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>'", function() Snacks.picker.resume() end, { desc = "Resume last picker" })
vim.keymap.set("n", "<leader>j", function() Snacks.picker.jumps() end, { desc = "Jumps picker" })
vim.keymap.set("n", "<leader>?", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>h", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set({ "n", "x" }, "<leader>*", function() Snacks.picker.grep_word({ ignored = false }) end, { desc = "Visual selection or word" })
vim.keymap.set("n", "<leader>i", function() Snacks.picker.icons() end, { desc = "Icons", })

-- Git
vim.keymap.set("n", "<leader>v", function() Snacks.picker.git_status({ ignored = false, }) end, { desc = "Git status" })
vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log_file() end, { desc = "Git log file" })
vim.keymap.set("n", "<leader>l", function() Snacks.lazygit() end, { desc = "Open lazygit" })
