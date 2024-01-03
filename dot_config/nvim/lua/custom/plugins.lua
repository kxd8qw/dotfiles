local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
  -- Override plugin definition options
  {
    "neovim/nvim-lspconfig",
    require("core.utils").load_mappings("lspconfig"),
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    require("core.utils").load_mappings("telescope"),
  },
  {
    "numToStr/Comment.nvim",
    config = function () require("Comment").setup() end,
  },

  -- override plugin configs
  { "hrsh7th/nvim-cmp", opts = overrides.nvimcmp, },
  { "nvim-treesitter/nvim-treesitter", opts = overrides.treesitter, },
  { "williamboman/mason.nvim", opts = overrides.mason, },
  { "nvim-tree/nvim-tree.lua", opts = overrides.nvimtree, },

  -- Install a plugin
  { "christoomey/vim-tmux-navigator", },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = { handlers = {}, },
  },
  {
    "leoluz/nvim-dap-go",
    event = "VeryLazy",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function (_, opts)
      require("core.utils").load_mappings("dap_go")
      require("dap-go").setup(opts)
    end,
  },
  {
    "mbbill/undotree",
    require("core.utils").load_mappings("undotree"),
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function ()
      require("core.utils").load_mappings("dap")
      require "custom.configs.dap"
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    event = "VeryLazy",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function ()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("core.utils").load_mappings("dap_python")
      require("dap-python").setup(path)
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function () require "custom.configs.lint" end,
  },
  {
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    opts = function () require "custom.configs.formatter" end,
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "olexsmir/gopher.nvim",
    event = "VeryLazy",
    ft = "go",
    config = function (_, opts)
      require("core.utils").load_mappings("gopher")
      require("gopher").setup(opts)
    end,
    build = function () vim.cmd [[silent! GoInstallDeps]] end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", },
    config = function ()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function ()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function ()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function ()
        dapui.close()
      end
    end,
  },
  {
    "rust-lang/rust.vim",
    event = "VeryLazy",
    ft = "rust",
    init = function () vim.g.rustfmt_autosave = 1 end,
  },
  {
    "saecki/crates.nvim",
    event = "VeryLazy",
    ft = { "rust", "toml" },
    dependencies = "hrsh7th/nvim-cmp",
    config = function (_, opts)
      require("core.utils").load_mappings("crates")
      require("crates").setup(opts)
      require("crates").show()
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    event = "VeryLazy",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function () return require "custom.configs.rust-tools" end,
    config = function (_, opts) require("rust-tools").setup(opts) end,
  },
  { "williamboman/mason-lspconfig.nvim", },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}
return plugins