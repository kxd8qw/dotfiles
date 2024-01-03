-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  nvdash = { load_on_startup = true, },
  statusline = {
    theme = "minimal", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default theme
    -- round and block will work for minimal theme only
    separator_style = "round",
  },
  theme = "catppuccin",

  ---@type Base46HLGroupsList
  hl_override = {
    Comment = { fg = "#707F95", italic = true, },
    ["@comment"] = { fg = "#707F95", italic = true, },
    ColorColumn = { bg = "red", fg="black2" },
    CursorColumn = { bg = "black2", },
    CursorLine = { bg = "black2", },
    NvimTreeOpenedFolderName = { fg = "green", bold = true, },
  },
  transparency = true,
}

return M