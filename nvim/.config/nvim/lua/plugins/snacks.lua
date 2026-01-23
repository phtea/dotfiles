vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
	lazygit = {
		win = {
			backdrop = false,
			style = "lazygit",
			height = 0.99,
			width = 0,
		},
		config = {
			os = {
				edit =
				'[ -z "\"$NVIM\"" ] && (nvim -- {{filename}}) || (nvim --server "\"$NVIM\"" --remote-send "\"q\"" && nvim --server "\"$NVIM\"" --remote {{filename}})',
				editAtLine =
				'[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" &&  nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
				openDirInEditor =
				'[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
				openInTerminal = '[ -z "$NVIM" ]',
			}
		},
	},
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
					["<Tab>"] = { "list_down", mode = { "i", "n" } },
					["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
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
				"**/*.gz", "**/*.zip", "**/*.tar", "**/*.tgz", "**/*.xz",
				"**/*.bz2", "**/*.7z", "**/*.rar", "**/*.zst", "**/*.jar", "**/*.war",
			},
		})
	end,
	{ desc = "Find files" }
)
vim.keymap.set("n", "<leader>F", function() Snacks.picker.files({ hidden = true, ignored = true, }) end,
	{ desc = "Find files (no ignores)" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep({ ignored = false }) end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>'", function() Snacks.picker.resume() end, { desc = "Resume last picker" })
vim.keymap.set("n", "<leader>j", function() Snacks.picker.jumps() end, { desc = "Jumps picker" })
vim.keymap.set("n", "<leader>?", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>h", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set({ "n", "x" }, "<leader>*", function() Snacks.picker.grep_word({ ignored = false }) end,
	{ desc = "Visual selection or word" })
vim.keymap.set("n", "<leader>i", function() Snacks.picker.icons() end, { desc = "Icons", })

-- Git
vim.keymap.set("n", "<leader>v", function() Snacks.picker.git_status({ ignored = false, }) end, { desc = "Git status" })
vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log_file() end, { desc = "Git log file" })
vim.keymap.set("n", "<leader>l", function() Snacks.lazygit() end, { desc = "Open lazygit" })

-- Lsp
vim.keymap.set("n", "<leader>d", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>D", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition", nowait = true })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration", nowait = true })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References", nowait = true })
vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation", nowait = true })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition", nowait = true })
