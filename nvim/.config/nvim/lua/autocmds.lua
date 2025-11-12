-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true, higroup = "WordSelected" })
	end,
})

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

-- Syntax highlighting for params files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("params_ft", { clear = true }),
	pattern = { "params_[0-9]*.txt", },
	callback = function()
		vim.bo.filetype = "json"
	end,
})

-- Syntax highlighting for yml files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("yml_ft", { clear = true }),
	pattern = { "*.yml", "*.yml.*" },
	callback = function()
		vim.bo.filetype = "yaml"
	end,
})

local notes_path = vim.fn.expand("~/notes.md")

vim.api.nvim_create_autocmd("BufLeave", {
  group = vim.api.nvim_create_augroup("ephemeral_notes", { clear = true }),
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name == notes_path then
      -- delete after the leave finishes to avoid weirdness
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.api.nvim_buf_delete(args.buf, { force = true })
        end
      end)
    end
  end,
})

-- Hook for when package is changed (installed, updated, deleted)
-- lazy-style build equivalent
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local data = ev.data or vim.v.event  -- depending on Neovim version

    if not data then
      return
    end

    local kind = data.kind         -- "install" | "update" | "delete"
    local spec = data.spec or {}
    local name = spec.name or ""

    -- Only for nvim-treesitter, and only on install or update
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      vim.cmd("TSUpdate")
    end
  end,
})
