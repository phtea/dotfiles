-- persistent-highlight.lua
local M = {}

-- TODO:
-- API
-- delete_current_match
-- highlight_word
-- highlight_selection
-- customisable color_groups

-- Predefined highlight groups with distinct colors
local color_groups = {
  { name = "PersistentHighlight1", guibg = "#4d2f2f" }, -- Slightly brighter dark red
  { name = "PersistentHighlight2", guibg = "#2f4d2f" }, -- Slightly brighter dark green
  { name = "PersistentHighlight3", guibg = "#2f2f4d" }, -- Slightly brighter dark blue
  { name = "PersistentHighlight4", guibg = "#4d4d2f" }, -- Slightly brighter dark yellow
  { name = "PersistentHighlight5", guibg = "#4d2f4d" }, -- Slightly brighter dark purple
  { name = "PersistentHighlight6", guibg = "#2f4d4d" }, -- Slightly brighter dark teal
}

local matches = {}
local next_color_index = 1

-- Initialize highlight groups
local function setup_highlights()
  for _, group in ipairs(color_groups) do
    vim.api.nvim_command(string.format(
      "highlight %s guibg='%s'",
      group.name, group.guibg
    ))
  end
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
function M.setup()
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
end

-- Auto-setup when loaded
M.setup()

return M
