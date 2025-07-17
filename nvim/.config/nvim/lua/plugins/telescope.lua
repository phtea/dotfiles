return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
	"nvim-lua/plenary.nvim",
	"polarmutex/git-worktree.nvim",
    },
    config = function()
	local telescope = require("telescope")
	local builtin = require("telescope.builtin")
	local themes = require("telescope.themes")

	telescope.setup({
	    defaults = {
		vimgrep_arguments = {
		    'rg', 
		    '--color=never', 
		    '--no-heading', 
		    '--with-filename', 
		    '--line-number', 
		    '--column', 
		    '--smart-case', 
		    '--hidden', 
		    '--glob',
		    '!{**/.git/*,**/node_modules/*,**/package-lock.json,**/yarn.lock}',
		},
	    },
	    pickers = {
		lsp_references = { initial_mode = "normal" },
		lsp_definitions = { initial_mode = "normal" },
		lsp_type_definitions = { initial_mode = "normal" },
		git_status = { initial_mode = "normal" },
		buffers = { initial_mode = "normal" },
		grep_string = { initial_mode = "normal" },
		diagnostics = { initial_mode = "normal" },
		resume = { initial_mode = "normal" },
	    },
	})

	telescope.load_extension("git_worktree")

	-- Hooks for git-worktree
	local Hooks = require("git-worktree.hooks")
	local config = require('git-worktree.config')
	local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

	-- Update buffers when switching
	Hooks.register(Hooks.type.SWITCH, function (path, prev_path)
	    vim.notify("Moved from " .. prev_path .. " to " .. path)
	    update_on_switch(path, prev_path)
	end)

	-- Handle worktree deletion
	Hooks.register(Hooks.type.DELETE, function ()
	    vim.cmd(config.update_on_change_command)
	end)

	-- Remove default LSP keymaps if present
	pcall(vim.keymap.del, "n", "gri")
	pcall(vim.keymap.del, "n", "grr")
	pcall(vim.keymap.del, "x", "gra")
	pcall(vim.keymap.del, "n", "gra")
	pcall(vim.keymap.del, "n", "grn")
	pcall(vim.keymap.del, "n", "gd")

	-- Keymaps
	vim.keymap.set("n", "<leader>f", function()
	    require("telescope.builtin").find_files({
		find_command = {
		    "rg",
		    "--files",
		    "--hidden",
		    "--glob",
		    '!{**/.git/*,**/node_modules/*,**/package-lock.json,**/.yarn/*}',
		},
	    })
	end, { desc = "Find files (.config/ but skip .git/)" })
	vim.keymap.set("n", "<leader>F", function() builtin.find_files({ hidden = true }) end, { desc = "Find files (all)" })
	vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "Find diagnostics" })
	vim.keymap.set("n", "<leader>g", builtin.git_status, { desc = "Find git status (and see diffs)" })
	vim.keymap.set("n", "<leader>j", builtin.jumplist, { desc = "Open jumplist picker" })
	vim.keymap.set("n", "<leader>'", builtin.resume, { desc = "Open last picker" })
	vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep (all)" })
	vim.keymap.set("n", "<leader>*", function() builtin.grep_string({ search = vim.fn.expand("<cword>") }) end, { desc = "Grep word under cursor" })
	vim.keymap.set("n", "<leader>8", function() builtin.grep_string({ search = vim.fn.expand("<cword>") }) end, { desc = "Grep word under cursor" })
	vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Find buffers" })
	vim.keymap.set("n", "<leader>w", function() telescope.extensions.git_worktree.git_worktree(themes.get_dropdown({ initial_mode = "normal" })) end, { desc = "Switch worktree" })
	vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Find references" })
	vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Find definitions" })
	vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "Find type definitions" })
    end,
}
