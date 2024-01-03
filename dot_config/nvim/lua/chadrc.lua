-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  transparency = true,

  ---@type Base46HLGroupsList
  hl_override = {
    Comment = { fg = "#707F95", italic = true },
    ["@comment"] = { fg = "#707F95", italic = true },
    ColorColumn = { bg = "red", fg = "black2" },
    CursorColumn = { bg = "black2" },
    CursorLine = { bg = "black2" },
    NvimTreeOpenedFolderName = { fg = "green", bold = true },
  },
}

M.mason = {
  pkgs = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "black",
    "css-lsp",
    "debugpy",
    "delve",
    "deno",
    "elixir-ls",
    "eslint-lsp",
    "html-lsp",
    "isort",
    "js-debug-adapter",
    "prettier",
    "python-lsp-server",
    "typescript-language-server",

    -- c/cpp/go/rust stuff
    "clangd",
    "clang-format",
    "codelldb",
    "gofumpt",
    "goimports-reviser",
    "golines",
    "gopls",
    "rust-analyzer",

    -- sysadmin stuff
    "ansible-language-server",
    "ansible-lint",
    "bash-language-server",
    "shellcheck",
    "shfmt",
  },
}

M.nvdash = { load_on_startup = true, }

M.ui = {
  statusline = {
    -- modules = { ft = function() return vim.bo.filetype .. " " end, },
    -- order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics",
    --       "lsp", "ft", "cwd", "cursor" },

    -- default/round/block/arrow separators work only for default theme
    -- round and block will work for minimal theme only
    separator_style = "round",
    theme = "minimal", -- default/vscode/vscode_colored/minimal
  },
}

return M