local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

local function add_mappings(bufnr)
  Opt_list = { buffer = bufnr, remap = false }
  require("core.utils").load_mappings("lsp")
  Opt_list = nil
end

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

lspconfig.ansiblels.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  commands = { AddMappings = { add_mappings, description = "Add mappings", }, },
  filetypes = ("yaml.ansible"),
})

lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  commands = { AddMappings = { add_mappings, description = "Add mappings", }, },
  filetypes = ("sh"),
  settings = {
    bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" },
  },
})

lspconfig.clangd.setup({
  on_attach = function (client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  commands = { AddMappings = { add_mappings, description = "Add mappings", }, },
  filetypes = { "c", "cpp" },
})

lspconfig.eslint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  commands = { AddMappings = { add_mappings, description = "Add mappings", }, },
  filetypes = { "javascript", "typescript" },
})

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  commands = { AddMappings = { add_mappings, description = "Add mappings", }, },
  cmd = { "gopls", },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = { unusedparams = true, },
    },
  },
})

lspconfig.pylsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  commands = { AddMappings = { add_mappings, description = "Add mappings", }, },
  filetypes = ("python"),
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "W391" },
          maxLineLength = 100,
        },
      },
    },
  },
})

lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  commands = {
    AddMappings = { add_mappings, description = "Add mappings", },
    OrganizeImports = { organize_imports, description = "Organize imports", },
  },
  -- init_options = {
  --   preferences = { disableSuggestions = true, },
  -- },
})

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    commands = {
      AddMappings = { add_mappings, description = "Add mappings", },
    },
  }
end