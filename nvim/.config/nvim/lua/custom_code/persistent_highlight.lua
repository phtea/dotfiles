local M = {}

-- TODO:
-- API
-- delete_current_match (when cursor is on match -> delete this match highlight)
-- highlight_selection (from visual selection)

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

-- List all current matches
function M.list_matches()
	if #matches == 0 then
		print("No active highlights")
		return
	end

	print("Active highlights:")
	for i, match in ipairs(matches) do
		print(string.format("  %d. Pattern: '%s' | Color: %s",
			i, match.pattern, match.group))
	end
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
	vim.api.nvim_create_user_command("Match", function(opts)
		if opts.args and opts.args ~= "" then
			M.match(opts.args)
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

	vim.api.nvim_create_user_command("ClearMatch", function(opts)
		if opts.args and opts.args ~= "" then
			M.clear_match(opts.args)
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
end

-- Auto-setup when loaded
M.setup()

return M
