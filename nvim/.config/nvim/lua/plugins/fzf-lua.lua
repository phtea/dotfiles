return {
  "ibhagwan/fzf-lua",
  enabled = false,
  keys = {
	{ "<leader>f",  function() require("fzf-lua").files() end,                 desc = "Find Files" },
	{
	  "<leader>F",
	  function() require("fzf-lua").files({ fd_opts = "--hidden --no-ignore" }) end,
	  desc = "Find files (no ignores)"
	},
	{
	  "<leader>n",
	  function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end,
	  desc = "Find Config File"
	},
	{ "<leader>/",  function() require("fzf-lua").live_grep() end,             desc = "Live Grep" },
	{ "<leader>*",  function() require("fzf-lua").grep_cword() end,            desc = "Grep word under cursor" },
	{ "<leader>b",  function() require("fzf-lua").buffers() end,               desc = "Buffers" },
	{ "<leader>gg", function() require("fzf-lua").git_status() end,            desc = "Git Status" },
	{ "<leader>'",  function() require("fzf-lua").resume() end,                desc = "Resume last picker" },
	{ "<leader>j",  function() require("fzf-lua").jumps() end,                 desc = "Jumps" },
	{ "<leader>?",  function() require("fzf-lua").keymaps() end,               desc = "Keymaps" },
	{ "<leader>h",  function() require("fzf-lua").help_tags() end,             desc = "Help Pages" },

	-- LSP
	{ "<leader>d",  function() require("fzf-lua").diagnostics_document() end,  desc = "Buffer Diagnostics" },
	{ "<leader>D",  function() require("fzf-lua").diagnostics_workspace() end, desc = "Workspace Diagnostics" },
	{ "gd",         function() require("fzf-lua").lsp_definitions() end,       desc = "Goto Definition" },
	{ "gD",         function() require("fzf-lua").lsp_declarations() end,      desc = "Goto Declaration" },
	{ "gr",         function() require("fzf-lua").lsp_references() end,        desc = "References" },
	{ "gI",         function() require("fzf-lua").lsp_implementations() end,   desc = "Goto Implementation" },
	{ "gy",         function() require("fzf-lua").lsp_typedefs() end,          desc = "Goto Type Definition" },
  },
  opts = {
	defaults = { hidden = true, },
	winopts = {
	  backdrop = 100,
	  border = "single",
	  preview = { border = "single", }
	},
  }
}
