local M = {}

-- TODO:
-- API
-- delete_current_match (when cursor is on match -> delete this match highlight)

-- Predefined highlight groups with distinct colors (defaults)
local default_color_groups = {
	{ name = "PersistentHighlight1", bg = "#4d2f2f" },
	{ name = "PersistentHighlight2", bg = "#2f4d2f" },
	{ name = "PersistentHighlight3", bg = "#2f2f4d" },
	{ name = "PersistentHighlight4", bg = "#4d4d2f" },
	{ name = "PersistentHighlight5", bg = "#4d2f4d" },
	{ name = "PersistentHighlight6", bg = "#2f4d4d" },
}

local matches = {}
local next_color_index = 1

local color_groups = default_color_groups

-- Initialize highlight groups (supports any hl fields)
local function setup_highlights()
	for _, group in ipairs(color_groups) do
		local name = group.name
		local hl = vim.tbl_deep_extend("force", {}, group)
		hl.name = nil
		vim.api.nvim_set_hl(0, name, hl)
	end
end

-- Escape text so it's treated as literal in Vim regex
local function escape_vim_literal(text)
	-- \V = very nomagic (treat almost everything as literal)
	-- still must escape backslashes
	return "\\V" .. text:gsub("\\", "\\\\")
end

function M.highlight_word()
	local word = vim.fn.expand("<cword>")
	if not word or word == "" then
		print("No word under cursor")
		return
	end

	-- whole-word match, literal
	local pattern = "\\<" .. escape_vim_literal(word) .. "\\>"

	M.match(pattern)
end

-- Add a match with automatic color cycling
function M.match(pattern)
	if #matches >= #color_groups then
		print("All highlight colors in use. Clear some with :ClearMatches")
		return
	end

	local group = color_groups[next_color_index]

	-- Create the match
	local match_id = vim.fn.matchadd(group.name, pattern)

	-- Store it
	table.insert(matches, {
		id = match_id,
		pattern = pattern,
		group = group.name
	})

	-- Update color index (cycle)
	next_color_index = next_color_index % #color_groups + 1

	print(string.format("Highlighted '%s' with %s", pattern, group.name))
end

-- Clear all matches
function M.clear_matches()
	for _, match in ipairs(matches) do
		vim.fn.matchdelete(match.id)
	end

	matches = {}
	next_color_index = 1

	print("Cleared all highlights")
end

-- Clear specific match by pattern
function M.clear_match(pattern)
	for i, match in ipairs(matches) do
		if match.pattern == pattern then
			vim.fn.matchdelete(match.id)
			table.remove(matches, i)
			print("Cleared highlight for: " .. pattern)
			return
		end
	end
	print("No highlight found for: " .. pattern)
end

function M.list_matches()
  if #matches == 0 then
    print("No active highlights")
    return
  end

  local lines = { "Active highlights:" }
  for i, match in ipairs(matches) do
    lines[#lines + 1] = string.format(
      "  %d. Pattern: '%s' | Color: %s",
      i, match.pattern, match.group
    )
  end

  print(table.concat(lines, "\n"))
end

-- Setup commands
function M.setup(opts)
	opts = opts or {}

	if opts.color_groups ~= nil then
		color_groups = opts.color_groups
		next_color_index = 1
	end

	setup_highlights()

	-- Create user commands
	vim.api.nvim_create_user_command("Match", function(params)
		if params.args and params.args ~= "" then
			M.match(params.args)
		else
			print("Usage: :Match /pattern/")
		end
	end, {
			nargs = 1,
			complete = function()
				return {"TODO", "FIXME", "NOTE", "WARNING"}
			end
		})

	vim.api.nvim_create_user_command("ClearMatches", function()
		M.clear_matches()
	end, {})

	vim.api.nvim_create_user_command("ClearMatch", function(params)
		if params.args and params.args ~= "" then
			M.clear_match(params.args)
		else
			print("Usage: :ClearMatch /pattern/")
		end
	end, {
			nargs = 1
		})

	vim.api.nvim_create_user_command("ListMatches", function()
		M.list_matches()
	end, {})

	vim.api.nvim_create_user_command("MatchWord", function()
		M.highlight_word()
	end, {})

	vim.api.nvim_create_user_command("MatchSelection", function()
		M.highlight_selection()
	end, { range = true })

	vim.api.nvim_create_user_command("DeleteCurrentMatch", function()
		M.delete_current_match()
	end, {})
end

local function get_selection_single_line()
	local mode = vim.fn.mode()
	local start_pos, end_pos

	if mode == "v" or mode == "V" or mode == "\22" then
		-- Visual mode: use visual start + cursor
		start_pos = vim.fn.getpos("v")
		end_pos   = vim.fn.getpos(".")
	else
		-- Not in visual: use '< and '>
		start_pos = vim.fn.getpos("'<")
		end_pos   = vim.fn.getpos("'>")
	end

	local srow, scol = start_pos[2], start_pos[3]
	local erow, ecol = end_pos[2], end_pos[3]

	if srow == 0 or erow == 0 then return nil, "no selection" end

	-- normalize
	if srow > erow or (srow == erow and scol > ecol) then
		srow, erow = erow, srow
		scol, ecol = ecol, scol
	end

	if srow ~= erow then
		return nil, "multiline selection not supported yet"
	end

	local line = vim.api.nvim_buf_get_lines(0, srow - 1, srow, false)[1] or ""
	-- getpos() columns are 1-based, Lua string indices are 1-based
	local text = line:sub(scol, ecol)
	if text == "" then return nil, "empty selection" end
	return text, nil
end

function M.highlight_selection()
	local text, err = get_selection_single_line()
	if not text then
		print(err)
		return
	end

	local pattern = escape_vim_literal(text)
	M.match(pattern)

	-- exit visual mode
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
		"n",
		false
	)
end

local function cursor_on_match(vim_pattern)
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local start = 0
	local col1 = col + 1 -- convert to 1-based

	while true do
		local res = vim.fn.matchstrpos(line, vim_pattern, start)
		local s, e = res[2], res[3]

		if s == -1 then
			return false
		end

		if col1 >= s and col1 <= e then
			return true
		end

		start = e
	end
end

function M.delete_current_match()
	if #matches == 0 then
		print("No active highlights")
		return
	end

	for i, m in ipairs(matches) do
		if cursor_on_match(m.pattern) then
			vim.fn.matchdelete(m.id)
			table.remove(matches, i)
			print("Deleted highlight: " .. m.pattern)
			return
		end
	end

	print("Cursor is not on a highlighted match")
end

-- Auto-setup when loaded
M.setup()

return M
