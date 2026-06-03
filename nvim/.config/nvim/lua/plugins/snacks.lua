vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
	picker = {
		layout = {
			layout = {
				box = "vertical",
				border = "none",

				{ -- preview ABOVE
					win = "preview",
					title_pos = "left",
					height = 0.65,
				},

				{ -- search/list BELOW
					box = "vertical",
					height = 0.35,

					{ -- picker title/status above actual input
						win = "input",
						height = 1,
						border = "top",
						title = " {title} {live} {flags} ",
						title_pos = "left",
					},

					{ win = "list" },
				},
			},
		},
		hidden = true,
		ignored = true,
		icons = { files = { enabled = false, }, },
		win = {
			input = {
				keys = {
					["<Esc>"] = { "close", mode = { "i", "n" } },
					["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
					["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
					["<F1>"] = { "toggle_help_input", mode = { "i", "n" } },
				}
			}
		},
	},
	bigfile = { enabled = true, notify = false, },
})

vim.keymap.set("n", "<leader><space>", function() Snacks.picker() end, { desc = "Picker of all pickers" })
vim.keymap.set("n", "<leader>f", function() Snacks.picker.files({ hidden = true, }) end, { desc = "Find files" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep({ ignored = false }) end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>b", function() Snacks.picker.buffers({ current = false, sort_lastused = true }) end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>'", function() Snacks.picker.resume() end, { desc = "Resume last picker" })
vim.keymap.set("n", "<leader>j", function() Snacks.picker.jumps() end, { desc = "Jumps picker" })
vim.keymap.set("n", "<leader>?", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>h", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set({ "n", "x" }, "<leader>*", function() Snacks.picker.grep_word({ ignored = false }) end, { desc = "Visual selection or word" })
vim.keymap.set("n", "<leader>i", function() Snacks.picker.icons() end, { desc = "Icons", })
vim.keymap.set("n", "<leader>v", function() Snacks.picker.git_status({ ignored = false, }) end, { desc = "Git status" })
