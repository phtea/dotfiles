vim.pack.add({
	"https://github.com/nvim-orgmode/orgmode",
	"https://github.com/nvim-orgmode/org-bullets.nvim"
})

require("orgmode").setup({
	org_agenda_files = "~/{org,notes}/**/*",
	org_default_notes_file = "~/org/refile.org",
	org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAIT(w)", "|", "DONE(d)", "CANCELLED(c)", },
	org_startup_indented = true,   
})

require('org-bullets').setup()

vim.keymap.set('n', '<leader>ot', "<CMD>Org agenda t<CR>")
