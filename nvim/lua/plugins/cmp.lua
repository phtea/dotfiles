return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
	},
	config = function()
		local cmp = require("cmp")
		local ls = require("luasnip")
		cmp.setup({
			snippet = {
				expand = function(args)
					ls.lsp_expand(args.body)
				end,
			},
			-- preselect = cmp.PreselectMode.Item,
			completion = {
				completeopt = "menu,menuone,noinsert", -- Ensures the menu is visible, but doesn’t insert text until confirmed
			},
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
				['<C-u>'] = cmp.mapping.scroll_docs(-4),
				['<C-d>'] = cmp.mapping.scroll_docs(4),
				['<C-f>'] = cmp.mapping(function(fallback)
					if ls.jumpable(1) then
						ls.jump(1)
					else
						fallback()
					end
				end, {'i', 's'}),

				['<C-b>'] = cmp.mapping(function(fallback)
					if ls.jumpable(-1) then
						ls.jump(-1)
					else
						fallback()
					end
				end, {'i', 's'}),
			}),
			sources = {
				{name = 'path'},
				{name = 'nvim_lsp', keyword_length = 1},
				{name = 'buffer', keyword_length = 3},
				{name = 'luasnip', keyword_length = 2},
			},
			formatting = {
				fields = {'menu', 'abbr', 'kind'},
				format = function(entry, item)
					local menu_icon = { nvim_lsp = 'λ', luasnip = '⋗', buffer = 'Ω', path = '🖫', }
					item.menu = menu_icon[entry.source.name]
					return item
				end,
			},
			-- window = {
			-- 	completion = cmp.config.window.bordered({
			-- 		border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }, -- Square border
			-- 	}),
			-- 	documentation = cmp.config.window.bordered({
			-- 		border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }, -- Square border
			-- 	}),
			-- },
			{ name = 'buffer' },
		})
	end,
}

