vim.keymap.set("v", "mf", ":norm mf<CR>", { buffer = true, silent = true, nowait = true })
vim.keymap.set("n", "m/", ":g//norm mf<CR>", { buffer = true, silent = true })

local function netrw_copy_marked()
  local files = vim.fn["netrw#Expose"]("netrwmarkfilelist")

  if type(files) ~= "table" or #files == 0 then
    print("No marked files")
    return
  end

  local uris = {}
  for _, f in ipairs(files) do
    table.insert(uris, "file://" .. vim.fn.fnamemodify(f, ":p"))
  end

  local data = table.concat(uris, "\n")
  vim.fn.system({ "xclip", "-selection", "clipboard", "-t", "text/uri-list" }, data)

  print("Copied " .. #files .. " file(s) to clipboard")
end
vim.keymap.set("n", "C", netrw_copy_marked, { buffer = true, nowait = true })
