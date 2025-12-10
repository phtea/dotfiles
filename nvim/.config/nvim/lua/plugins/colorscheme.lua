vim.pack.add({ "https://github.com/Mofiqul/vscode.nvim", })

vim.cmd.colorscheme "vscode"

vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#113d6f" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "LspReferenceText" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "LspReferenceText" })
vim.api.nvim_set_hl(0, "LspReferenceTarget", { link = "LspReferenceText" })
vim.api.nvim_set_hl(0, "Visimatch", { bg = "#373737" })
