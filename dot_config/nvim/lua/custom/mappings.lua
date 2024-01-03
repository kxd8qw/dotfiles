---@type MappingsTable
local M = {}

M.general = {
  c = {
    ["w!!"] = { "silent! w !sudo tee >/dev/null '%' | e!", "sudo write a file"},
    -- Emacs like keys for the command line
    ["<A-Backspace>"] = { "<C-w>", "Backwards delete word" },
    ["<A-Left>"] = { "<S-Left>", "Previous word" },
    ["<A-Right>"] = { "<S-Right>", "Next word" },
    ["<C-a>"] = { "<Home>", "Beginning of line" },
    ["<C-e>"] = { "<End>", "End of line" },
    ["<C-b>"] = { "<Left>", "Move left" },
    ["<C-f>"] = { "<Right>", "Move right" },
    ["<Esc>b"] = { "<S-Left>", "Move word left" },
    ["<Esc>f"] = { "<S-Right>", "Move word right" },
  },

  i = {
    ["<C-S-d>"] = { "<C-r>=strftime('%F')<CR>", "Insert time" },
    ["<C-a>"] = { "<Home>", "Beginning of line" },
    ["<C-j>"] = { "<C-o>gj", "Move down" }, -- Handle line wraps
    ["<C-k>"] = { "<C-o>gk", "Move up" }, -- Handle line wraps
    ["<C-z>"] = { "<C-g>u<C-u>", "Undo" },
    ["<Down>"] = { "<C-o>gj", "Move down" },
    ["<Up>"] = { "<C-o>gk", "Move up" },
    -- Emacs like keys for insert mode
    ["<A-Backspace>"] = { "<-g>db<C-u>", "Backwards delete word" },
    ["<A-Del>"] = { "<-g>dw<C-u>", "Delete word" },
    ["<A-Left>"] = { "<C-o>b", "Previous word" },
    ["<A-Right>"] = { "<C-o>w", "Next word" },
  },

  n = {
    ["<C-Left>"] = { "<C-w>h", "Window left" },
    ["<C-Right>"] = { "<C-w>l", "Window right" },
    ["<C-Down>"] = { "<C-w>j", "Window down" },
    ["<C-Up>"] = { "<C-w>k", "Window up" },
    ["<leader><CR>"] = { "<cmd>noh<CR>", "Clear highlights" },
    ["<leader><leader>"] = { "<cmd>so<CR>", "Source buffer" },
    ["<leader>j"] = { "<cmd>cnext<CR>zz", "Next QuickFix" },
    ["<leader>k"] = { "<cmd>cprev<CR>zz", "Previous QuickFix" },
    ["<leader>S"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
          "Global replace current word" },
    ["S"] = { ":%s///gI<Left><Left><Left><Left>", "Substitution template" },
    ["<leader>d"] = { [["_d]], "Delete" }, -- Don't stomp clipboard
    ["<leader>ss"] = { "<cmd>setlocal spell!<CR>", "Toggle spell check" },
    ["<leader>sn"] = { "]s", "Next spelling error" },
    ["<leader>sp"] = { "[s", "Previous spelling error" },
    ["<leader>s?"] = { "z=", "Suggest spelling" },
    ["<leader>sa"] = { "zg", "Add spelling to directory" },
    ["<leader>xx"] = { "<cmd>!chmod +x %<CR>", "Make file executable",
          opts = { silent = true } },
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["."] = { "mz.`z", "Repeat last change" }, -- Make '.' not move the cursor
    ["&"] = { "<cmd>&&<CR>", "Repeat last substitute" },
    ["Q"] = { "gqap", "Hard re-wrap paragraph" },
    ["Y"] = { "y$", "Yank to end of line" },
    ["p"] = { "]p", "Paste" }, -- Paste at the right indent
    -- Edit NeoVim config
    ["<leader>nc"] = {
      "<cmd>badd ~/.config/nvim/lua/custom/init.lua<CR><cmd>blast<CR>",
      "Edit neovim init"
    },
    ["<leader>nm"] = {
      "<cmd>badd ~/.config/nvim/lua/custom/mappings.lua<CR><cmd>blast<CR>",
      "Edit neovim mappings"
    },
    ["<leader>np"] = {
      "<cmd>badd ~/.config/nvim/lua/custom/plugins.lua<CR><cmd>blast<CR>",
      "Edit neovim plugins"
    },
    -- Folding
    ["<leader>f"] = { "zi", "Toggle folding" },
    ["<leader>fd"] = {
      function ()
        vim.opt.foldclose = "all"
        vim.opt.foldcolumn = 1
        vim.opt.foldmethod = "diff"
        vim.opt.foldenable = true
      end,
      "Fold by diff"
    },
    ["<leader>fi"] = {
      function ()
        vim.opt.foldclose = "all"
        vim.opt.foldcolumn = 1
        vim.opt.foldmethod = "indent"
        vim.opt.foldenable = true
      end,
      "Fold by indent"
    },
    ["<leader>fs"] = {
      function ()
        vim.opt.foldclose = "all"
        vim.opt.foldcolumn = 1
        vim.cmd("syn region myFold start='{' end='}' transparent fold")
        vim.cmd("syn sync fromstart")
        vim.opt.foldmethod = "syntax"
        vim.opt.foldenable = true
      end,
      "Fold by syntax"
    },
    ["<leader>ft"] = { "Vatzf", "Fold by tags" },
    ["<leader>M"] = { "zM", "Close all folds" },
    ["<leader>m"] = { "zMzv", "Close folds, except current" },
    ["<leader>o"] = { "zO", "Open all folds under cursor" },
  },

  v = {
    [">"] = { ">gv", "indent"},
    ["<"] = { "<gv", "outdent"},
    ["J"] = { ":m '>+1<CR>gv=gv", "Move highligeted lines down" },
    ["K"] = { ":m '<-2<CR>gv=gv", "Move highligeted lines up" },
    ["S"] = { ":s///gI<Left><Left><Left><Left>", "Substitution template" },
  },

  x = {
    ["<leader>d"] = { [["_d]], "Delete" }, -- Don't stomp clipboard
    ["<leader>p"] = { [["_dP]], "Paste" }, -- Don't stomp clipboard
    ["&"] = { "<cmd>&&<CR>", "Repeat last substitute" },
  },
}

-- Plugin keymaps

M.crates = {
  plugin = true,
  n = {
    ["<leader>rcu"] = {
      function () require("crates").upgrade_all_crates() end,
      "Update crates"
    },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = { "<cmd>DapToggleBreakpoint<CR>", "Add a breakpoint" },
    ["<leader>dr"] = { "<cmd>DapContinue<CR>", "Run or continue the debugger" },
  },
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgl"] = {
      function () require("dap-go").debug_last() end,
      "Debug last go test"
    },
    ["<leader>dgt"] = {
      function () require("dap-go").debug_test() end,
      "Debug go test"
    },
  },
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function () require("dap_python").test_method() end,
      "Run or continue the debugger"
    },
  },
}

M.diff = {
  plugin = true,
  n = {
    ["<A-Left>"] = { "[c", "Copy diffs left<-right", opts = { silent = true } },
    ["<A-Right>"] = { "]c", "Copy diffs left->right", opts = { silent = true }},
    ["<A-Down>"] = { "do", "Next diff", opts = { silent = true } },
    ["<A-Up>"] = { "dp", "Previous diff", opts = { silent = true } },
    ["<A-r>"] = { "<cmd>diffupdate<CR>", "Update diff", opts = {silent = true}},
  },
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = { "<cmd>GoTagAdd json<CR>", "Add json struct tags" },
    ["<leader>gsy"] = { "<cmd>GoTagAdd yaml<CR>", "Add yaml struct tags" },
  },
}

M.lsp = {
  plugin = true,
  i = {
    ["<C-h>"] = { vim.lsp.buf.signature_help, "Signature Help",opts = Opt_list},
  },

  n = {
    ["<leader>gf"] = { vim.lsp.buf.format, "Format buffer", opts = Opt_list },
    ["<leader>vca"] = { vim.lsp.buf.code_action,
          "View code actions", opts = Opt_list },
    ["<leader>vd"] = { vim.diagnostic.open_float,
          "View diagnostic", opts = Opt_list },
    ["<leader>vrn"] = { vim.lsp.buf.rename, "Rename symbol", opts = Opt_list },
    ["<leader>vrr"] = { vim.lsp.buf.references,
          "View references", opts = Opt_list },
    ["<leader>vws"] = { vim.lsp.buf.workspace_symbol,
          "View workspace symbols", opts = Opt_list },
    ["]d"] = { vim.diagnostic.goto_next, "Next diagnostic", opts = Opt_list },
    ["[d"] = { vim.diagnostic.goto_prev, "Prev diagnostic", opts = Opt_list },
    ["gd"] = { vim.lsp.buf.definition, "Goto definition", opts = Opt_list },
    ["gr"] = { vim.lsp.buf.references, "Get references", opts = Opt_list },
    ["K"] = { vim.lsp.buf.hover, "Info on symbol", opts = Opt_list },
  },
}

M.telescope = {
  plugin = true,
  n = {
    ["<leader>pb"] = {
      "<cmd>lua require('telescope.builtin').buffers()<CR>",
      "Pick buffers"
    },
    ["<leader>pf"] = {
      "<cmd>lua require('telescope.builtin').find_files()<CR>",
      "Pick files"
    },
    ["<C-p>"] = {
      "<cmd>lua require('telescope.builtin').live_grep()<CR>",
      "Pick files via grep"
    },
    ["<leader>ps"] = {
    -- function ()
    --   require('telescope.builtin').grep_string({
    --     search = vim.fn.input("Grep > ")
    -- --   })
    -- end,
      "<cmd>lua require('telescope.builtin').grep_string()<CR>",
      "Pick files via grep"
    },
    ["<leader>vh"] = {
      "<cmd>lua require('telescope.builtin').help_tags()<CR>",
      "Pick help tags"
    },
  },
}

M.undotree = {
  plugin = true,
  n = {
    ["<leader>u"] = { "vim.cmd.UndotreeToggle", "Toggle Undotree" },
  },
}

return M