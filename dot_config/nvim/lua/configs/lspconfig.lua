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
  { "html", { filetypes = "html" } },
  { "cssls", { filetypes = "css" } },
  { "ansiblels", { filetypes = "yaml.ansible" } },
  { "bashls",
    {
      filetypes = "sh",
      settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" } }
    }
  },
  { "clangd",
    {
      filetypes = { "c", "cpp" },
      init_options = { fallbackFlags = { "--std=c23" } },
      on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        nvlsp.on_attach(client, bufnr)
      end
    }
  },
  { "eslint", { filetypes = "javascript" } },
  { "gopls",
    {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = util.root_pattern("go.work", "go.mod", ".git"),
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
    {
      filetypes = "python",
      settings = { pylsp = { plugins = { pycodestyle = {
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
      filetypes = "typescript",
      -- init_options = {
      --   preferences = { disableSuggestions = true, },
      -- }
    }
  },
  { "yamlls", { filetypes = "yaml" } }
}

for _, lsp in pairs(servers) do
  local name, config = lsp[1], lsp[2]
  vim.lsp.enable(name)
  if config then
    vim.lsp.config(name, config)
  end
end

-- read :h vim.lsp.config for changing options of lsp servers