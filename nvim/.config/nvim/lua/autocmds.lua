-- Open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- No auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- Universal highlight on cursor hold (works with search, LSP, etc)
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("UniversalHighlight", { clear = true }),
  desc = "Highlight word under cursor universally",
  callback = function()
    if vim.fn.mode() ~= "i" then
      local word = vim.fn.expand('<cword>')
      if word ~= '' and #word > 1 then
        -- Clear previous highlights
        vim.fn.clearmatches()
        -- Highlight all occurrences of the current word in buffer
        vim.fn.matchadd('WordSelected', '\\<' .. vim.fn.escape(word, '\\/') .. '\\>')
      end
    end
  end,
})

-- Clear highlights when moving cursor away or entering insert mode
vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI", "InsertEnter"}, {
  group = "UniversalHighlight", 
  desc = "Clear universal highlights",
  callback = function()
    vim.fn.clearmatches()
  end,
})
