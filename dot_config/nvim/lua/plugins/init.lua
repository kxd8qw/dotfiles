---@type NvPluginSpec[]
return {
  -- Override plugin definition options
  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`,
  -- `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin
  -- spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }

  -- override plugin configs
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "nvchad.configs.cmp"
      M.completion.completeopt = "menu,menuone,noselect"
      table.insert(M.sources, { name = "crates" })
      return M
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function() require "configs.lspconfig" end,
    -- local Opt_list = { buffer = bufnr, remap = false }
    -- Was sot for all keys: opts = Opt_list },
    keys = {
      { "<C-h>", vim.lsp.buf.signature_help, desc = "Signature Help",
            mode = "i" },
      { "<leader>vca", vim.lsp.buf.code_action, desc = "View code actions" },
      { "<leader>vd", vim.diagnostic.open_float, desc = "View diagnostic" },
      { "<leader>vrn", vim.lsp.buf.rename, desc = "Rename symbol" },
      { "<leader>vrr", vim.lsp.buf.references, desc = "View references" },
      { "<leader>vws", vim.lsp.buf.workspace_symbol,
            desc = "View workspace symbols" },
      { "gd", vim.lsp.buf.definition, desc = "Goto definition" },
      { "K", vim.lsp.buf.hover, desc = "Info on symbol" },
    },
  },
  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-p>", function() require("telescope.builtin").live_grep() end,
            desc = "Pick via grep", },
      { "<leader>pb", function() require("telescope.builtin").buffers() end,
            desc = "Pick buffers", },
      { "<leader>pf", function() require("telescope.builtin").find_files() end,
            desc = "Pick files", },
      { "<leader>ps", function() require("telescope.builtin").grep_string() end,
            desc = "Pick via grep", },
      { "<leader>vh", function() require("telescope.builtin").help_tags() end,
            desc = "Pick help tags", },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    -- git support in nvimtree
    opts = {
      git = { enable = true },
      renderer = { highlight_git = true, icons = { show = { git = true } } },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      autotag = { enable = true, }, -- automatic closing tags
      highlight = { enable = true, }, -- syntax highlighting
      indent = { enable = true, }, -- indentation disable = { "python", },
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
        "just",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
  },

  -- Install plugins
  {
    "chipsenkbeil/distant.nvim",
    keys = { { "<leader>dd", function() require("distant"):setup() end,
          desc = "Start Distant" }, },
  },
  { "christoomey/vim-tmux-navigator" },
  {
    "echasnovski/mini.nvim", version = false,
    config = function()
      require("mini.ai").setup()
      require("mini.operators").setup()
      require("mini.surround").setup()
    end,
    lazy = false,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap", },
    opts = { handlers = {} },
  },
  {
    "leoluz/nvim-dap-go",
    config = function(_, opts) require("dap-go").setup(opts) end,
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", },
    ft = "go",
    keys = {
      { "<leader>dgl", function() require("dap-go").debug_last() end,
            desc = "Debug last go test", },
      { "<leader>dgt", function() require("dap-go").debug_test() end,
            desc = "Debug go test", },
    },
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "vim.cmd.UndotreeToggle", desc = "Toggle Undotree" },
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function() require "configs.dap" end,
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<CR>",
            desc = "Toggle breakpoint" },
      { "<leader>dr", "<cmd>DapContinue<CR>",
            desc = "Run or continue the debugger" },
      { "<leader>dus", function()
          local widgets = require "dap.ui.widgets"
          local sidebar = widgets.sidebar(widgets.scopes)
          sidebar.open()
        end, desc = "Open debugging sidebar",
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", },
    ft = "python",
    keys = {
      { "<leader>dpr", function() require("dap_python").test_method() end,
            desc = "Run or continue the debugger", },
    },
  },
  {
    "mfussenegger/nvim-lint",
    config = function() require "configs.lint" end,
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "olexsmir/gopher.nvim",
    build = function() vim.cmd [[silent! GoInstallDeps]] end,
    config = function(_, opts) require("gopher").setup(opts) end,
    ft = "go",
    keys = {
      { "<leader>gsj", "<cmd>GoTagAdd json<CR>", desc = "Add json struct tags" },
      { "<leader>gsy", "<cmd>GoTagAdd yaml<CR>", desc = "Add yaml struct tags" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function() vim.g.rustfmt_autosave = 1 end,
  },
  {
    "saecki/crates.nvim",
    config = function(_, opts)
      require("crates").setup(opts)
      require("cmp").setup.buffer { sources = { name = "crates" } }
      require("crates").show()
    end,
    ft = { "rust", "toml" },
    keys = {
      { "<leader>rcu", function() require("crates").upgrade_all_crates() end,
            desc = "Update crates", },
    },
  },
  {
    "simrat39/rust-tools.nvim",
    config = function(_, opts) require("rust-tools").setup(opts) end,
    dependencies = "neovim/nvim-lspconfig",
    ft = "rust",
    opts = require "configs.rust-tools",
  },
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = { smear_replace_mode = true, },
  },
  {
    "stevearc/conform.nvim",
    -- event = "BufWritePost", -- uncomment for format on save
    opts = require "configs.conform",
    keys = {
      { "<leader>gf", function() require("conform").format() end,
            desc = "Format buffer" },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  { "williamboman/mason-lspconfig.nvim" },
}