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
      { "<C-h>",       vim.lsp.buf.signature_help, desc = "Signature Help",
            mode = "i" },
      { "<leader>vca", vim.lsp.buf.code_action,    desc = "View code actions" },
      { "<leader>vd",  vim.diagnostic.open_float,  desc = "View diagnostic" },
      { "<leader>vrn", vim.lsp.buf.rename,         desc = "Rename symbol" },
      { "<leader>vrr", vim.lsp.buf.references,     desc = "View references" },
      { "<leader>vws", vim.lsp.buf.workspace_symbol,
            desc = "View workspace symbols" },
      { "gd",          vim.lsp.buf.definition,     desc = "Goto definition" },
      { "K",           vim.lsp.buf.hover,          desc = "Info on symbol" },
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
            desc = "Pick via grep" },
      { "<leader>pb", function() require("telescope.builtin").buffers() end,
            desc = "Pick buffers" },
      { "<leader>pf", function() require("telescope.builtin").find_files() end,
            desc = "Pick files" },
      { "<leader>ps", function() require("telescope.builtin").grep_string() end,
            desc = "Pick via grep" },
      { "<leader>vh", function() require("telescope.builtin").help_tags() end,
            desc = "Pick help tags" },
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
      auto_install = true,
      autotag = { enable = true },   -- automatic closing tags
      highlight = { enable = true }, -- syntax highlighting
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = { "<leader>ss",    desc = "Selection start" },
          node_incremental = { "<leader>si",  desc = "Selection increment" },
          scope_incremental = { "<leader>sc", desc = "Selection scope" },
          node_decremental = { "<leader>sd",  desc = "Selection decrement" },
        },
      },
      indent = { enable = true }, -- indentation disable = { "python" },
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
  {
    "williamboman/mason.nvim",
    opts = { ui = { border = "rounded" } },
  },
  -- Install plugins
  {
    "chipsenkbeil/distant.nvim",
    keys = { { "<leader>dd", function() require("distant"):setup() end,
          desc = "Start Distant" } },
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
    dependencies = { "mason.nvim", "nvim-dap" },
    opts = { handlers = {} },
  },
  {
    "leoluz/nvim-dap-go",
    config = function(_, opts) require("dap-go").setup(opts) end,
    dependencies = { "nvim-dap", "nvim-dap-ui" },
    ft = "go",
    keys = {
      { "<leader>dgl", function() require("dap-go").debug_last() end,
            desc = "Debug last go test" },
      { "<leader>dgt", function() require("dap-go").debug_test() end,
            desc = "Debug go test" },
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
    dependencies = { "nvim-dap", "nvim-dap-ui" },
    ft = "python",
    keys = {
      { "<leader>dpr", function() require("dap_python").test_method() end,
            desc = "Run or continue the debugger" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    config = function() require "configs.lint" end,
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for
      -- built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          -- You can choose the select mode (default is charwise 'v')
          selection_modes = {
            -- ['@parameter.outer'] = 'v', -- charwise
            -- ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject
          -- is extended to include preceding or succeeding whitespace.
          include_surrounding_whitespace = true,
        },
      }
    end,
  },
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
    dependencies = { "nvim-dap", "nvim-nio" },
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
            desc = "Update crates" },
    },
  },
  {
    "simrat39/rust-tools.nvim",
    config = function(_, opts) require("rust-tools").setup(opts) end,
    dependencies = "nvim-lspconfig",
    ft = "rust",
    opts = require "configs.rust-tools",
  },
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = { smear_replace_mode = true },
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
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "ansible-language-server",
        "bash-language-server",
        "clangd",
        "css-lsp",
        "elixir-ls",
        "eslint-lsp",
        "gopls",
        "html-lsp",
        "lua-language-server",
        "python-lsp-server",
        "rust-analyzer",
        "typescript-language-server",
        "yaml-language-server",
      }
    }
  }
}