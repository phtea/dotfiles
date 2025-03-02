return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			local lspconfig = require("lspconfig")

			-- Utility function to generate keymap options
			local function set_opts(desc, bufnr)
				return { desc = "LSP: " .. desc, buffer = bufnr, silent = true, nowait = true }
			end

			local on_attach = function(_, bufnr)
				-- Use Telescope for LSP actions
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", set_opts("Go to definition (Telescope)", bufnr))
				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", set_opts("References (Telescope)", bufnr))
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", set_opts("Go to implementation (Telescope)", bufnr))
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", set_opts("Go to type definition (Telescope)", bufnr))
				vim.keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", set_opts("Find symbols in current file", bufnr))
				vim.keymap.set("n", "<leader>dws", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", set_opts("Find symbols across project", bufnr))
				vim.keymap.set("n", "<leader>sd", vim.diagnostic.open_float, set_opts("Show diagnostic in floating window", bufnr))

				-- Other LSP mappings
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, set_opts("Code actions", bufnr))
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, set_opts("Rename symbol", bufnr))
			end

			-- Use a loop to conveniently call 'setup' on multiple servers and
			local servers = {'gopls', 'pyright', 'clangd', 'rust_analyzer', }
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			-- Configure diagnostics globally
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
			})

		end,
	},
}

