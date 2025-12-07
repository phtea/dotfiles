local M = {}

-- LSP CompletionItemKind (1..25) -> icon
M.lsp_kind = {
  [1]  = "󰉿", -- Text
  [2]  = "󰆧", -- Method
  [3]  = "󰊕", -- Function
  [4]  = "",  -- Constructor
  [5]  = "󰜢", -- Field
  [6]  = "󰀫", -- Variable
  [7]  = "󰠱", -- Class
  [8]  = "",  -- Interface
  [9]  = "󰏗", -- Module
  [10] = "󰜢", -- Property
  [11] = "󰑭", -- Unit
  [12] = "󰎠", -- Value
  [13] = "",  -- Enum
  [14] = "󰌋", -- Keyword
  [15] = "",  -- Snippet
  [16] = "󰏘", -- Color
  [17] = "󰈙", -- File
  [18] = "󰈇", -- Reference
  [19] = "󰉋", -- Folder
  [20] = "",  -- EnumMember
  [21] = "󰏿", -- Constant
  [22] = "󰙅", -- Struct
  [23] = "",  -- Event
  [24] = "󰆕", -- Operator
  [25] = "󰊄", -- TypeParameter
}

M.lsp_kind_hl = {
  [1]  = "PmenuKindText",
  [2]  = "PmenuKindMethod",
  [3]  = "PmenuKindFunction",
  [4]  = "PmenuKindConstructor",
  [5]  = "PmenuKindField",
  [6]  = "PmenuKindVariable",
  [7]  = "PmenuKindClass",
  [8]  = "PmenuKindInterface",
  [9]  = "PmenuKindModule",
  [10] = "PmenuKindProperty",
  [11] = "PmenuKindUnit",
  [12] = "PmenuKindValue",
  [13] = "PmenuKindEnum",
  [14] = "PmenuKindKeyword",
  [15] = "PmenuKindSnippet",
  [16] = "PmenuKindColor",
  [17] = "PmenuKindFile",
  [18] = "PmenuKindReference",
  [19] = "PmenuKindFolder",
  [20] = "PmenuKindEnumMember",
  [21] = "PmenuKindConstant",
  [22] = "PmenuKindStruct",
  [23] = "PmenuKindEvent",
  [24] = "PmenuKindOperator",
  [25] = "PmenuKindTypeParam",
}

function M.kind_icon(kind, fallback)
  return M.lsp_kind[kind] or fallback or "·"
end

function M.kind_hl(kind, fallback)
  return M.lsp_kind_hl[kind] or fallback or ""
end

return M
