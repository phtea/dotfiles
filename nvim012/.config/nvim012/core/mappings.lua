vim.g.mapleader = " "

vim.keymap.set("n", "-", ":Ex<CR>", { silent = true })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("v", "<leader>", [["+y]])

vim.keymap.set("n", "<A-j>", ":cn<CR>")
vim.keymap.set("n", "<A-k>", ":cp<CR>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<leader>t", function()
    local script = "tmux neww ~/.tmux/tmux-sessionizer"
    local ok, output = pcall(vim.fn.system, script)

    if not ok then
        vim.notify("Ошибка вызова tmux-sessionizer: " .. output, vim.log.levels.ERROR)
        return
    end

    if vim.v.shell_error ~= 0 then
        vim.notify("tmux-sessionizer завершился с ошибкой:\n" .. output, vim.log.levels.WARN)
    else
        vim.notify("tmux-sessionizer выполнен успешно", vim.log.levels.INFO)
    end
end, { desc = "Запуск tmux-sessionizer", silent = true })
