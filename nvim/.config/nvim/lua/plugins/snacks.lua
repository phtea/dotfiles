return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
	picker = {
	  hidden = true,
	  ignored = true,
	  win = {
		input = {
		  keys = {
			["<Tab>"] = { "list_down", mode = { "i", "n" } },
			["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
		  }
		}
	  }
	},
	bigfile = { enabled = true },
	statuscolumn = { enabled = true },
  },
  keys = {
	{ "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
	{ "<leader>f",       function() Snacks.picker.files({ hidden = true, }) end,                 desc = "Find files" },
	{ "<leader>F",       function() Snacks.picker.files({ hidden = true, ignored = true, }) end, desc = "Find files (no ignores)" },
	{ "<leader>n",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
	{ "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Live grep" },
	{ "<leader>b",       function() Snacks.picker.buffers() end,                                 desc = "Find buffers" },
	{ "<leader>gg",      function() Snacks.picker.git_status() end,                              desc = "Git status" },
	{ "<leader>'",       function() Snacks.picker.resume() end,                                  desc = "Resume last picker" },
	{ "<leader>j",       function() Snacks.picker.jumps() end,                                   desc = "Resume last picker" },
	{ "<leader>?",       function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
	{ "<leader>h",       function() Snacks.picker.help() end,                                    desc = "Help Pages" },
	{ "<leader>*",       function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
	{ "<leader>i",       function() Snacks.picker.icons() end,                                   desc = "Icons", },
	-- Lsp
	{ "<leader>d",       function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
	{ "<leader>D",       function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
	{ "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
	{ "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
	{ "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
	{ "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
	{ "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
  },
}
