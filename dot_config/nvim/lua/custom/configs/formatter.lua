local M = {
  filetype = {
    c = { require("formatter.filetypes.c").clang_format },
    cpp = { require("formatter.filetypes.cpp").clang_format },
    go = {
      require("formatter.filetypes.go").gofumpt,
      require("formatter.filetypes.go").goimports_reviser,
      require("formatter.filetypes.go").golines,
    },
    python = { require("formatter.filetypes.python").black },
    javascript = { require("formatter.filetypes.javascript").prettier },
    typescript = { require("formatter.filetypes.typescript").prettier },
    sh = { require("formatter.filetypes.sh").shellcheck },
    ["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace }
  }
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave", "BufWritePost" }, {
  command = "FormatWriteLock"
})
return M