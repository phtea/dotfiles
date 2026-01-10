if true then return {} end -- disable for now

vim.pack.add({ "https://github.com/jake-stewart/multicursor.nvim" })

local mc = require("multicursor-nvim")
mc.setup()

local set = vim.keymap.set

-- Add or skip cursor above/below the main cursor.
set({"n", "x"}, "<C-k>", function() mc.lineAddCursor(-1) end)
set({"n", "x"}, "<C-j>", function() mc.lineAddCursor(1) end)
set({"n", "x"}, "<M-k>", function() mc.lineSkipCursor(-1) end)
set({"n", "x"}, "<M-j>", function() mc.lineSkipCursor(1) end)

-- Add or skip adding a new cursor by matching word/selection
set({"n", "x"}, "<C-n>", function() mc.matchAddCursor(1) end)
set({"n", "x"}, "<A-n>", function() mc.matchSkipCursor(1) end)
set({"n", "x"}, "<C-p>", function() mc.matchAddCursor(-1) end)
set({"n", "x"}, "<A-p>", function() mc.matchSkipCursor(-1) end)

-- Add and remove cursors with control + left click.
set("n", "<c-leftmouse>", mc.handleMouse)
set("n", "<c-leftdrag>", mc.handleMouseDrag)
set("n", "<c-leftrelease>", mc.handleMouseRelease)

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)
	-- Select a different cursor as the main one.
	layerSet({"n", "x"}, "<left>", mc.prevCursor)
	layerSet({"n", "x"}, "<right>", mc.nextCursor)

	-- Delete the main cursor.
	layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

	-- Enable and clear cursors using escape.
	layerSet("n", "<esc>", function()
		if not mc.cursorsEnabled() then
			mc.enableCursors()
		else
			mc.clearCursors()
		end
	end)

	-- Align cursor columns.
	layerSet("n", "<leader>a", mc.alignCursors)

	-- Rotate the text contained in each visual selection between cursors.
	layerSet("x", "<leader>t", function() mc.transposeCursors(1) end)
	layerSet("x", "<leader>T", function() mc.transposeCursors(-1) end)

	-- Increment/decrement sequences, treating all cursors as one sequence.
	layerSet({"n", "x"}, "g<c-a>", mc.sequenceIncrement)
	layerSet({"n", "x"}, "g<c-x>", mc.sequenceDecrement)
end)

-- Pressing `gaip` will add a cursor on each line of a paragraph.
-- Can also be used to add cursor for each line of visual selection.
set({"n", "x"}, "ga", mc.addCursorOperator)

-- Split visual selections by regex.
set("x", "S", mc.splitCursors)

-- Match new cursors within visual selections by regex.
set("x", "M", mc.matchCursors)

-- Bring back cursors if you accidentally clear them
set("n", "<leader>gv", mc.restoreCursors)

-- Add a cursor for all matches of cursor word/selection in the document.
set({"n", "x"}, "<leader>A", mc.matchAllAddCursors)

-- Append/insert for each line of visual selections.
-- Similar to block selection insertion.
set("x", "I", mc.insertVisual)
set("x", "A", mc.appendVisual)
