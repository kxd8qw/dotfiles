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
    "yaml-language-server",
  },
}

M.nvdash = { load_on_startup = true }

M.ui = {
  statusline = {
    modules = { ft = function()
      return vim.o.columns > 79
            and table.concat { '%#Comment#', " ", vim.bo.filetype, " " } or ""
    end, },
    order = { "mode", "file", "ft", "git", "%=", "lsp_msg", "%=", "diagnostics",
          "lsp", "cwd", "cursor" },

    -- default/round/block/arrow separators: won't work for vscode themes
    separator_style = "round",
    -- tabufline = { lazyload = false },
    theme = "default", -- default/vscode/vscode_colored/minimal
  },
}

return M