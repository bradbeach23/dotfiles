-- Otto: matching the VS Code, Ghostty and desktop palette.
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.g.colors_name = "otto"
local p = require("otto.palette")
local function hi(name, spec) vim.api.nvim_set_hl(0, name, spec) end
local function link(name, target) hi(name, { link = target }) end

local groups = {
  Normal = { fg = p.fg, bg = p.bg }, NormalNC = { fg = p.fg, bg = p.bg },
  NormalFloat = { fg = p.fg, bg = p.raised }, FloatBorder = { fg = p.border, bg = p.raised },
  FloatTitle = { fg = p.coral, bg = p.raised, bold = true },
  Cursor = { fg = p.bg, bg = p.coral }, CursorLine = { bg = p.raised },
  CursorColumn = { bg = p.raised }, ColorColumn = { bg = p.sidebar },
  LineNr = { fg = p.comment }, CursorLineNr = { fg = p.coral, bold = true },
  SignColumn = { bg = p.bg }, FoldColumn = { fg = p.comment, bg = p.bg },
  Folded = { fg = p.muted, bg = p.sidebar }, EndOfBuffer = { fg = p.border },
  NonText = { fg = p.border }, Whitespace = { fg = p.border },
  WinSeparator = { fg = p.chrome, bg = p.chrome },
  Visual = { bg = p.hover }, Search = { fg = p.gold, bg = p.hover },
  IncSearch = { fg = p.chrome, bg = p.gold }, CurSearch = { fg = p.chrome, bg = p.coral },
  MatchParen = { fg = p.gold, bg = p.hover, bold = true },
  Pmenu = { fg = p.fg, bg = p.raised }, PmenuSel = { fg = p.fg, bg = p.hover },
  PmenuSbar = { bg = p.sidebar }, PmenuThumb = { bg = p.border },
  StatusLine = { fg = p.fg, bg = p.chrome }, StatusLineNC = { fg = p.muted, bg = p.chrome },
  TabLine = { fg = p.muted, bg = p.sidebar }, TabLineFill = { bg = p.chrome },
  TabLineSel = { fg = p.coral, bg = p.bg, bold = true },
  WinBar = { fg = p.muted, bg = p.bg }, WinBarNC = { fg = p.comment, bg = p.bg },
  Directory = { fg = p.teal }, Title = { fg = p.coral, bold = true },
  ErrorMsg = { fg = p.coral }, WarningMsg = { fg = p.gold }, MoreMsg = { fg = p.teal },
  Question = { fg = p.teal }, Conceal = { fg = p.comment },
  Comment = { fg = p.comment, italic = true }, Constant = { fg = p.purple },
  String = { fg = p.teal }, Character = { fg = p.teal }, Number = { fg = p.purple },
  Boolean = { fg = p.purple }, Float = { fg = p.purple }, Identifier = { fg = p.fg },
  Function = { fg = p.gold }, Statement = { fg = p.coral }, Operator = { fg = "#d8dee9" },
  PreProc = { fg = p.coral }, Type = { fg = p.blue }, Special = { fg = p.gold },
  Delimiter = { fg = "#c2cbd6" }, Underlined = { fg = p.blue, underline = true },
  Ignore = { fg = p.comment }, Error = { fg = p.coral }, Todo = { fg = p.gold, bold = true },
  Added = { fg = p.teal }, Changed = { fg = p.gold }, Removed = { fg = p.coral },
  DiffAdd = { bg = "#294b4e" }, DiffChange = { bg = "#49463e" },
  DiffText = { bg = "#665337" }, DiffDelete = { fg = p.coral, bg = p.hover },
  SpellBad = { sp = p.coral, undercurl = true }, SpellCap = { sp = p.gold, undercurl = true },
  SpellRare = { sp = p.purple, undercurl = true }, SpellLocal = { sp = p.teal, undercurl = true },
}
for name, spec in pairs(groups) do hi(name, spec) end
for _, suffix in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
  local color = ({ Error = p.coral, Warn = p.gold, Info = p.teal, Hint = p.purple, Ok = p.green })[suffix]
  hi("Diagnostic" .. suffix, { fg = color })
  hi("DiagnosticVirtualText" .. suffix, { fg = color, bg = p.sidebar })
  hi("DiagnosticUnderline" .. suffix, { sp = color, undercurl = true })
end
for _, name in ipairs({ "LspReferenceText", "LspReferenceRead", "LspReferenceWrite" }) do
  hi(name, { bg = p.hover })
end
hi("LspInlayHint", { fg = p.comment, bg = p.sidebar })

-- Treesitter and semantic tokens share the VS Code syntax roles.
local captures = {
  ["@variable"] = "Identifier", ["@variable.builtin"] = "Constant",
  ["@variable.member"] = "Identifier", ["@constant"] = "Constant",
  ["@module"] = "Type", ["@string"] = "String", ["@character"] = "Character",
  ["@number"] = "Number", ["@boolean"] = "Boolean", ["@type"] = "Type",
  ["@attribute"] = "Special", ["@property"] = "Identifier", ["@function"] = "Function",
  ["@constructor"] = "Type", ["@operator"] = "Operator", ["@keyword"] = "Statement",
  ["@punctuation"] = "Delimiter", ["@comment"] = "Comment", ["@tag"] = "Statement",
  ["@tag.attribute"] = "Special", ["@tag.delimiter"] = "Delimiter",
  ["@markup.heading"] = "Title", ["@markup.raw"] = "String", ["@markup.link"] = "Underlined",
  ["@markup.list"] = "Special", ["@diff.plus"] = "Added", ["@diff.minus"] = "Removed",
  ["@diff.delta"] = "Changed",
}
for name, target in pairs(captures) do link(name, target) end
hi("@variable.parameter", { fg = "#d8dee9" })
hi("@markup.strong", { bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.strikethrough", { strikethrough = true })
for token, target in pairs({ namespace = "Type", type = "Type", class = "Type", enum = "Type",
  interface = "Type", struct = "Type", typeParameter = "Type", parameter = "@variable.parameter",
  variable = "Identifier", property = "Identifier", enumMember = "Constant", event = "Special",
  ["function"] = "Function", method = "Function", keyword = "Statement", string = "String",
  number = "Number", comment = "Comment", operator = "Operator", decorator = "Special" }) do
  link("@lsp.type." .. token, target)
end
link("@lsp.mod.readonly", "Constant")

-- LazyVim: explorer, pickers, completion, tabs, dashboard and supporting UI.
for _, name in ipairs({ "SnacksPickerList", "SnacksPickerPreview", "SnacksPickerInput",
  "SnacksPickerBox", "SnacksPickerNormal", "NeoTreeNormal", "NeoTreeNormalNC" }) do
  hi(name, { fg = p.fg, bg = p.sidebar })
end
for _, name in ipairs({ "SnacksPickerBorder", "SnacksPickerListBorder", "SnacksPickerPreviewBorder",
  "SnacksPickerInputBorder", "SnacksPickerBoxBorder" }) do hi(name, { fg = p.border, bg = p.sidebar }) end
local plugin_links = {
  SnacksPickerDir = "Comment", SnacksPickerDirectory = "Directory", SnacksPickerMatch = "Special",
  SnacksPickerTitle = "Title", SnacksPickerListCursorLine = "PmenuSel",
  SnacksPickerSelected = "Special", SnacksDashboardHeader = "Title", SnacksDashboardIcon = "Special",
  SnacksDashboardKey = "Statement", SnacksDashboardDesc = "Identifier", SnacksDashboardFooter = "Comment",
  SnacksIndent = "Whitespace", SnacksIndentScope = "Comment", SnacksNotifierInfo = "DiagnosticInfo",
  SnacksNotifierWarn = "DiagnosticWarn", SnacksNotifierError = "DiagnosticError",
  NeoTreeDirectoryName = "Directory", NeoTreeDirectoryIcon = "Directory", NeoTreeCursorLine = "PmenuSel",
  TelescopeNormal = "NormalFloat", TelescopeBorder = "FloatBorder", TelescopeSelection = "PmenuSel",
  TelescopeMatching = "Special", BlinkCmpMenu = "Pmenu", BlinkCmpMenuBorder = "FloatBorder",
  BlinkCmpMenuSelection = "PmenuSel", BlinkCmpLabelMatch = "Special", BlinkCmpGhostText = "Comment",
  BlinkCmpDoc = "NormalFloat", BlinkCmpDocBorder = "FloatBorder",
  GitSignsAdd = "Added", GitSignsChange = "Changed", GitSignsDelete = "Removed",
  WhichKey = "Statement", WhichKeyGroup = "Special", WhichKeyDesc = "Identifier",
  WhichKeyNormal = "NormalFloat", WhichKeyBorder = "FloatBorder",
  TroubleNormal = "NormalFloat", TroubleNormalNC = "NormalFloat",
  LazyNormal = "NormalFloat", LazyButton = "TabLine", LazyButtonActive = "PmenuSel",
  MasonNormal = "NormalFloat", NoiceCmdlinePopup = "NormalFloat", NoiceCmdlinePopupBorder = "FloatBorder",
  FlashLabel = "IncSearch", FlashMatch = "Search", FlashBackdrop = "Comment",
}
for name, target in pairs(plugin_links) do link(name, target) end
hi("BufferLineFill", { bg = p.chrome })
for _, suffix in ipairs({ "", "Visible", "Selected" }) do
  local bg = suffix == "Selected" and p.bg or p.sidebar
  local fg = suffix == "Selected" and p.fg or p.muted
  for _, name in ipairs({ "Buffer", "Background", "CloseButton", "Numbers", "Modified" }) do
    hi("BufferLine" .. name .. suffix, { fg = fg, bg = bg, bold = suffix == "Selected" })
  end
  hi("BufferLineIndicator" .. suffix, { fg = p.coral, bg = bg })
  hi("BufferLineSeparator" .. suffix, { fg = p.chrome, bg = bg })
end
local ansi = { p.sidebar, p.coral, p.green, p.gold, p.blue, p.purple, p.teal, "#d8dee9",
  "#8998ab", "#ff938a", "#b3d99a", "#ffda9e", "#a9c4ff", "#d8b4f2", "#7ee0d4", p.fg }
for i, color in ipairs(ansi) do vim.g["terminal_color_" .. (i - 1)] = color end
