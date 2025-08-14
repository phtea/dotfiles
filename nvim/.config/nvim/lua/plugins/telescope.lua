return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim", },
  config = function()
	local telescope = require("telescope")
	local builtin = require("telescope.builtin")

	telescope.setup({
	  defaults = {
		mappings = {
		  i = {
			["<Tab>"] = 'move_selection_next',
			["<S-Tab>"] = 'move_selection_previous',
		  },
		  n = {
			["q"] = 'close',
			["f"] = 'to_fuzzy_refine',
		  }
		},
		vimgrep_arguments = {
		  'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',
		  '--column', '--smart-case', '--hidden', '--glob',
		  '!{**/.git/*,**/node_modules/*,**/package-lock.json,**/yarn.lock}',
		},
		borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
		selection_caret = '',
		entry_prefix = '',
		prompt_prefix = '',
	  },
	})

	-- Remove default LSP keymaps if present
	pcall(vim.keymap.del, "n", "gri")
	pcall(vim.keymap.del, "n", "grr")
	pcall(vim.keymap.del, "x", "gra")
	pcall(vim.keymap.del, "n", "gra")
	pcall(vim.keymap.del, "n", "grn")
	pcall(vim.keymap.del, "n", "grc")
	pcall(vim.keymap.del, "n", "grt")
	pcall(vim.keymap.del, "n", "gd")

	-- Keymaps
	vim.keymap.set("n", "<leader>f", function()
	  builtin.find_files({
		find_command = {
		  "rg", "--files", "--hidden", "--glob",
		  '!{**/.git/*,**/node_modules/*,**/yarn.lock,**/*.png,**/*.o,**/*.jpeg,**/*.jpg,**/*.gif,**/*.pdf,**/*.zip,**/*.tar.gz,**/*.so,**/*.dll,**/*.exe}',
		},
	  })
	end, { desc = "Telescope: Find files" })
	vim.keymap.set("n", "<leader>F", function() builtin.find_files({ hidden = true }) end, { desc = "Telescope: Find files (+hidden)" })
	vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "Telescope: Find diagnostics" })
	vim.keymap.set("n", "<leader>gg", builtin.git_status, { desc = "Telescope: Find changed files (git)" })
	vim.keymap.set("n", "<leader>j", builtin.jumplist, { desc = "Telescope: Find jumplist" })
	vim.keymap.set("n", "<leader>'", builtin.resume, { desc = "Telescope: Open last picker" })
	vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope: Global grep search" })
	vim.keymap.set("n", "<leader>*", function() builtin.grep_string({ search = vim.fn.expand("<cword>") }) end,
	  { desc = "Telescope: Global grep search (current word)" })
	vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Telescope: Find buffers" })
	vim.keymap.set("n", "<leader>h", builtin.help_tags, { desc = "Telescope: Find help" })
	vim.keymap.set("n", "<leader>?", builtin.keymaps, { desc = "Telescope: Find keymaps" })
	vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Telescope: Find references" })
	vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Telescope: Find definitions" })
	vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "Telescope: Find type definitions" })
  end,
}
