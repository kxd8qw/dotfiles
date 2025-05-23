require("nvchad.configs.lspconfig").defaults()

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local util = require "lspconfig/util"

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
end

lspconfig.ansiblels.setup {
  filetypes = "yaml.ansible",
}

lspconfig.bashls.setup {
  filetypes = "sh",
  settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" }, },
}

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
  filetypes = { "c", "cpp" },
}

lspconfig.eslint.setup {
  filetypes = { "javascript", "typescript" },
}

lspconfig.gopls.setup {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = { unusedparams = true },
    },
  },
}

lspconfig.pylsp.setup {
  filetypes = "python",
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "E111", "E114", "E126", "E128", "W292", "W503" },
          maxLineLength = 100,
        },
      },
    },
  },
}

lspconfig.ts_ls.setup {
  commands = {
    OrganizeImports = { organize_imports, description = "Organize imports" },
  },
  -- init_options = {
  --   preferences = { disableSuggestions = true, },
  -- },
}

lspconfig.yamlls.setup {
  filetypes = "yaml",
}

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers