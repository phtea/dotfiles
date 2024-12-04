return {
	"stevearc/conform.nvim",
	enabled = false,
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				go = { "goimports", "gofmt" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				["*"] = { "codespell" },
				["_"] = { "trim_whitespace" },
			},
			format_on_save = {
				lsp_format = "fallback", -- Use LSP as fallback if no formatter is available
				timeout_ms = 500, -- Timeout for formatting
			},
			notify_on_error = true, -- Notify when a formatter errors
			notify_no_formatters = true, -- Notify when no formatters are available
		})

		-- Set up format on save for all files
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})

		-- Set formatexpr to use conform for formatting
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
