return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		opts = { auto_install = true, },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			'saghen/blink.cmp',
			{
				"folke/lazydev.nvim",
				opts = {
					library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } }, },
				},
			},
		},
		config = function()
			local capabilities = require('blink.cmp').get_lsp_capabilities()
			local lspconfig = require("lspconfig")

			-- Utility function for setting keymaps
			local function set_opts(desc, bufnr)
				return { desc = "LSP: " .. desc, buffer = bufnr, silent = true, nowait = true }
			end

			local on_attach = function(_, bufnr)
				-- LSP Keymaps (Uses Telescope)
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", set_opts("Go to definition", bufnr))
				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", set_opts("Find references", bufnr))
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", set_opts("Go to implementation", bufnr))
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", set_opts("Go to type definition", bufnr))
				vim.keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", set_opts("Find symbols in file", bufnr))
				vim.keymap.set("n", "<leader>dws", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", set_opts("Find symbols in workspace", bufnr))

				vim.keymap.set("n", "<leader>sd", vim.diagnostic.open_float, set_opts("Show diagnostics", bufnr))
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, set_opts("Code actions", bufnr))
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, set_opts("Rename symbol", bufnr))
				vim.keymap.set("n", "<leader>fmt", vim.lsp.buf.format, set_opts("Format buffer", bufnr))
			end

			-- Automatically set up installed servers
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
			})
		end,
	},
}
