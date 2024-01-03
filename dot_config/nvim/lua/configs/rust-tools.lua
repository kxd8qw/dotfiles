local base = require "nvchad.configs.lspconfig"
local on_attach = base.on_attach
local on_init = base.on_init
local capabilities = base.capabilities

local options = {
  server = {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  },
}
return options