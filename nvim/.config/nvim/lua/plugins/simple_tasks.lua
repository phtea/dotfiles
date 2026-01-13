vim.pack.add {
	{ src = "https://github.com/phtea/simple_tasks.nvim", version='dev' }, -- remote plugin
	-- { src = vim.fn.expand("~/code/lua/simple_tasks.nvim") }, -- local testing
}

local st = require("simple_tasks")
st.setup({ picker = "ui" })

-- Execute tasks
vim.keymap.set("n", "<leader>x", st.pick, { desc = "Project tasks", })
