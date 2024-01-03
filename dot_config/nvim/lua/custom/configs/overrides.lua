local M = {}

M.nvimcmp = {
  function ()
    local N = require "plugins.configs.cmp"
    table.insert(M.sources, { name = "crates" })
    return N
  end,
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.mason = {
  ensure_installed = {
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
    "gofumpt",
    "goimports-reviser",
    "golines",
    "gopls",
    "html-lsp",
    "js-debug-adapter",
    "prettier",
    "python-lsp-server",
    "typescript-language-server",

    -- c/cpp stuff
    "clangd",
    "clang-format",
    "codelldb",

    -- sysadmin stuff
    "ansible-language-server",
    "bash-language-server",
    "shellcheck",
  },
}

M.treesitter = {
  ensure_installed = {
    "awk",
    "bash",
    "c",
    "cpp",
    "css",
    "dockerfile",
    "elixir",
    "git_config",
    "gitignore",
    "git_rebase",
    "go",
    "html",
    "ini",
    "javascript",
    "json",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "rust",
    "tsx",
    "typescript",
    "vim",
    "xml",
    "yaml",
  },

  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

return M