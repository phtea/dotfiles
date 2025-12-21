vim.keymap.set("n", "<leader>s", [[:cdo %s/\<<C-R><C-W>\>/<C-R><C-W>/gIc<Left><Left><Left><Left>]], {
  buffer = true,
  desc = "Replace word under cursor in quickfix list"
})

vim.keymap.set("v", "<leader>s", [[y<Esc>:cdo %s/<C-R>"/<C-R>"/gIc<Left><Left><Left><Left>]], {
  buffer = true,
  desc = "Replace visual selection in quickfix list"
})
