local H = require("core.helper_functions")

-- Leader key
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", "<C-W>", { remap = true, desc = "Window prefix remap" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank: to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+y$]], { desc = "Yank: to system clipboard to EOL" })
vim.keymap.set("n", "<leader>c", [[<CMD>%y+<CR>]], { desc = "Copy full file content" })

vim.keymap.set("n", "<F1>", "<CMD>cprev<CR>", { silent = true, desc = "Quickfix: prev" }) -- Deprecated in favour of M-p
vim.keymap.set("n", "<F2>", "<CMD>cnext<CR>", { silent = true, desc = "Quickfix: next" }) -- Deprecated in favour of M-n
vim.keymap.set({ "n", "i" }, "<M-p>", "<CMD>cprev<CR>", { silent = true, desc = "Quickfix: prev" })
vim.keymap.set({ "n", "i" }, "<M-n>", "<CMD>cnext<CR>", { silent = true, desc = "Quickfix: next" })

vim.keymap.set("n", "<Esc>", "<CMD>nohlsearch<CR>", { silent = true, desc = "Hide highlight" })
vim.keymap.set("n", "<leader>=", "gg=G``", { desc = "Reindent whole file" })

vim.keymap.set("n", "<leader>p", H.copy_relative_path, { desc = "Copy: relative path" })

-- Lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Goto Definition", })
vim.keymap.set("n", "<leader>td", H.toggle_diagnostics, { desc = "LSP: Toggle diagnostics" })
vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0, desc = "LSP: Format buffer" })

-- Lazygit
vim.keymap.set("n", "<leader>gl", function()
  local file = vim.fn.expand("%:.")
  vim.cmd("term lazygit --filter=" .. vim.fn.shellescape(file))
end, { desc = "Lazygit current file history" })
vim.keymap.set("n", "<leader>l", "<CMD>term lazygit<CR>", { desc = "Lazygit" })

-- Perfect.
vim.keymap.set("n", "<leader>x", ":ene|setl bt=nofile bh=wipe|0r !", { desc = "Scratch buffer + shell output" })

-- AlignRegexp (straight from Emacs)
vim.keymap.set("x", "<leader>a", ":AlignRegex<space>", { desc = "Align by regexp", })
vim.api.nvim_create_user_command("AlignRegex", function(opts)
  local pattern = opts.args
  local start_line = opts.line1
  local end_line = opts.line2

  if pattern == "" then return end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  local max_width = 0
  local data = {}

  for i, line in ipairs(lines) do
    local m = vim.fn.matchstrpos(line, pattern)

    -- m = { matched_text, start_index, end_index }
    if m[2] >= 0 then
      local before = line:sub(1, m[2])
      local before_trimmed = before:gsub("%s+$", "")
      local width = vim.fn.strdisplaywidth(before_trimmed)

      data[i] = {
        start_col = m[2],
        before = before_trimmed,
        after = line:sub(m[2] + 1),
        width = width,
      }

      max_width = math.max(max_width, width)
    end
  end

  for i, line in ipairs(lines) do
    local d = data[i]

    if d then
      local spaces = string.rep(" ", max_width - d.width + 1)
      lines[i] = d.before .. spaces .. d.after
    end
  end

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end, {
  range = true,
  nargs = 1,
})
