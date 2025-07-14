return {
    "neovim/nvim-lspconfig",
    config = function()
	local lspconfig = require('lspconfig')
	lspconfig.pyright.setup{}
	lspconfig.solargraph.setup{}
	-- lspconfig.ruby_lsp.setup{}
	lspconfig.clangd.setup{}

	vim.api.nvim_create_autocmd("LspAttach", {
	    callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
		vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0 })
		vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	    end,
	})

	-- Toggle Lsp diagnostics (start with this boolean)
	local diagnostics_enabled = true

	vim.diagnostic.enable(diagnostics_enabled, …)

	vim.api.nvim_create_user_command("LspToggleDiagnostic", function()
	    diagnostics_enabled = not diagnostics_enabled

	    if diagnostics_enabled then
		vim.diagnostic.enable(true)
		vim.diagnostic.config({
		    virtual_text = false,
		    virtual_lines = false,
		})
		print("✅ LSP diagnostics enabled (virtual lines)")
	    else
		vim.diagnostic.enable(false)
		print("🚫 LSP diagnostics disabled")
	    end
	end, {})
    end,
}
