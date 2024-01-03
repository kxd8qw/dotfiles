-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table w/ variables fg, bg, bold, italic, etc.
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    fg = "#707F95",
    italic = true,
  },
  ColorColumn = { bg = "red", fg="black2" },
  CursorColumn = { bg = "black2", },
  CursorLine = { bg = "black2", },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true, },
}

return M