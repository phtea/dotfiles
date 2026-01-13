vim.pack.add {
	{ src = "https://github.com/phtea/simple_tasks.nvim" },
}

local st = require("simple_tasks")
st.setup({ picker = "ui" })

vim.keymap.set("n", "<leader>tt", st.pick, { desc = "Project tasks", })
