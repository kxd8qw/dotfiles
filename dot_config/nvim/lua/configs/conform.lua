local options = {
  formatters_by_ft = {
    c = { "clang_format", "trim_newlines", "trim_whitespace" },
    cpp = { "clang_format", "trim_newlines", "trim_whitespace" },
    css = { "prettier", "trim_newlines", "trim_whitespace" },
    go = { "gofumpt", "goimports_reviser", "golines", "trim_newlines",
      "trim_whitespace" },
    html = { "prettier", "trim_newlines", "trim_whitespace" },
    javascript = { "prettier", "trim_newlines", "trim_whitespace" },
    lua = { "stylua", "trim_newlines", "trim_whitespace" },
    python = { "black", "isort", "trim_newlines", "trim_whitespace" },
    sh = { "shellcheck", "shfmt", "trim_newlines", "trim_whitespace" },
    typescript = { "prettier", "trim_newlines", "trim_whitespace" },
    ["*"] = { "trim_newlines", "trim_whitespace" },
  },

  format_after_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)

require("conform").formatters.shfmt = { prepend_args = { "-ci", "-i", "2" }, }