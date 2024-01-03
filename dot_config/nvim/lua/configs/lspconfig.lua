require("nvchad.configs.lspconfig").defaults()

-- https://neovim.io/doc/user/lsp.html
local nvlsp = require "nvchad.configs.lspconfig"
local util = require "lspconfig/util"

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
end

local servers = {
  { "htmlls" },
  { "cssls" },
  { "ansiblels", { filetypes = "yaml.ansible" } },
  { "bashls",
    {
      settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" } }
    }
  },
  { "clangd", { init_options = { fallbackFlags = { "--std=c23" } } } },
  { "eslint" },
  { "gopls",
    {
      cmd = { "gopls" },
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = { unusedparams = true }
        }
      }
    }
  },
  { "pylsp",
    { settings = { pylsp = { plugins = { pycodestyle = {
        ignore = { "E111", "E114", "E126", "E128", "W292", "W503" },
        maxLineLength = 100
      } } } }
    }
  },
  { "ts_ls",
    {
      commands = {
        OrganizeImports = { organize_imports, description = "Organize imports" }
      },
    }
  },
  { "yamlls" }
}

for _, lsp in pairs(servers) do
  local name, config = lsp[1], lsp[2]
  vim.lsp.enable(name)
  if config then
    vim.lsp.config(name, config)
  end
end

-- read :h vim.lsp.config for changing options of lsp servers