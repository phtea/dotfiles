-- Colorscheme
vim.cmd.colorscheme("slate")

local function hl(name, opts) vim.api.nvim_set_hl(0, name, opts) end

-- hl("Title", { fg = "#ffffff", bold = true })
hl("ModeMsg", { fg = "#ffd700", bg = "NONE" })
hl("VertSplit", { fg = "#808080", bg = "NONE" })
hl("TelescopeSelection", { bg = "#45452B" })
hl("NormalFloat", { fg = "#ffffff", bg = "NONE" })
hl("Structure", { fg = "#c67bcc" })
hl("MatchParen", { bg = "#477eb5", bold = true })
hl("CursorLineNr", { fg = "#d6b695", bold = true })

-- Line numbers
hl("LineNr", { fg = "#deb48a" })
hl("LineNrAbove", { fg = "#666666" })
hl("LineNrBelow", { fg = "#666666" })

hl("Visual", { bg = "#45452B" })

-- Illuminated words theme
hl("IlluminatedWordText", { bg = "#3e4452" })
hl("IlluminatedWordRead", { bg = "#3e4452" })
hl("IlluminatedWordWrite", { bg = "#3e4452" })

-- Status line transparent
hl("StatusLineNC", { bg = "NONE" })
hl("StatusLine",   { bg = "NONE" })

-- GitSigns colors
hl('Added',    { fg = '#00dd00' })
hl('Changed', { fg = '#0000dd' })
hl('Removed', { fg = '#dd0000' })
