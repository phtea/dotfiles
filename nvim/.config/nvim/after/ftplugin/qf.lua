vim.keymap.set("n", "<leader>s", function()
  local word = vim.fn.expand("<cword>")
  local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
  if replacement == "" then return end
  vim.cmd(string.format([[silent! cdo %%s/\<%s\>/%s/gIc]], word, replacement))
end, { buffer = true, desc = "Replace word under cursor in quickfix list" })

vim.keymap.set("v", "<leader>s", function()
  vim.cmd('normal! "vy')
  local selection = vim.fn.getreg("v"):gsub("\n", "")
  local replacement = vim.fn.input("Replace '" .. selection .. "' with: ")
  if replacement == "" then return end
  vim.cmd(string.format([[silent! cdo %%s/%s/%s/gIc]], selection, replacement))
end, { buffer = true, desc = "Replace visual selection in quickfix list" })
