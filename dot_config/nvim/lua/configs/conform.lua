local options = {
  formatters_by_ft = {
    c = { "clang_format", "trim_newlines", "trim_whitespace" },
    cpp = { "clang_format", "trim_newlines", "trim_whitespace" },
    css = { "prettier", "trim_newlines", "trim_whitespace" },
    go = { "gofumpt", "goimports_reviser", "golines", "trim_newlines",
          "trim_whitespace", },
    html = { "prettier", "trim_newlines", "trim_whitespace" },
    javascript = { "prettier", "trim_newlines", "trim_whitespace" },
    lua = { "stylua", "trim_newlines", "trim_whitespace" },
    python = { "black", "isort", "trim_newlines", "trim_whitespace" },
    sh = { "shellcheck", "shfmt", "trim_newlines", "trim_whitespace" },
    typescript = { "prettier", "trim_newlines", "trim_whitespace" },
    ["*"] = { "trim_newlines", "trim_whitespace" },
  },

  formatters = {
    shfmt = { prepend_args = { "-ci", "-i", "2", "-kp", }, }
  },
}

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })

return options