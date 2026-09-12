local p = require("otto.palette")
local function mode(color)
  return {
    a = { fg = p.chrome, bg = color, gui = "bold" },
    b = { fg = p.fg, bg = p.hover },
    c = { fg = p.muted, bg = p.chrome },
  }
end
return {
  normal = mode(p.coral), insert = mode(p.teal), visual = mode(p.purple),
  replace = mode(p.gold), command = mode(p.gold), terminal = mode(p.teal),
  inactive = { a = { fg = p.muted, bg = p.chrome }, b = { fg = p.muted, bg = p.chrome },
    c = { fg = p.muted, bg = p.chrome } },
}
