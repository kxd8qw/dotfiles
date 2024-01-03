---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  nvdash = { load_on_startup = true, },
  statusline = {
    theme = "minimal", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default theme
    -- round and block will work for minimal theme only
    separator_style = "round",
  },
  theme = "catppuccin",

  hl_override = highlights.override,
  hl_add = highlights.add,
  transparency = true,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M