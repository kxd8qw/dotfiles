require "nvchad.mappings"
local map = vim.keymap.set

-- Add yours here

-- Command Mode
map("c", "w!!", "silent! w !pkexec tee >/dev/null '%' | e!",
      { desc = "sudo write a file" })
  -- Emacs like keys for the command line
map("c", "<A-Backspace>", "<C-w>", { desc = "Backwards delete word" })

-- Command & Insert Modes
  -- Emacs like keys for the command & insert modes
map({ "c", "i" }, "<C-a>", "<Home>", { desc = "Beginning of line" })
map({ "c", "i" }, "<C-e>", "<End>", { desc = "End of line" })
map({ "c", "i" }, "<C-b>", "<Left>", { desc = "Move left" })
map({ "c", "i" }, "<C-f>", "<Right>", { desc = "Move right" })
map({ "c", "i" }, "<A-Left>", "<S-Left>", { desc = "Previous word" })
map({ "c", "i" }, "<A-Right>", "<S-Right>", { desc = "Next word" })
map({ "c", "i" }, "<Esc>b", "<S-Left>", { desc = "Previous word" })
map({ "c", "i" }, "<Esc>f", "<S-Right>", { desc = "Next word" })

-- Insert Mode
map("i", "<C-S-d>", "<C-r>=strftime('%F')<CR>", { desc = "Insert time" })
map("i", "<C-j>", "<C-o>gj", { desc = "Move down" })
map("i", "<C-k>", "<C-o>gk", { desc = "Move up" })
map("i", "<C-z>", "<C-g>u<C-u>", { desc = "Undo" })
map("i", "<Down>", "<C-o>gj", { desc = "Move down" })
map("i", "<Up>", "<C-o>gk", { desc = "Move up" })
  -- Emacs like keys for insert mode
map("i", "<A-Backspace>", "<C-g>db<C-u>", { desc = "Backwards delete word" })
map("i", "<A-Del>", "<C-g>dw<C-u>", { desc = "Delete word" })

-- Normal Mode
map("n", "<C-Down>", "<C-w>j", { desc = "Window down" })
map("n", "<C-Left>", "<C-w>h", { desc = "Window left" })
map("n", "<C-Right>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<C-w>k", { desc = "Window up" })
map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Create virtical split" })
map("n", "<leader>_", "<cmd>split<CR>", { desc = "Create horizontal split" })
map("n", "<leader><CR>", "<cmd>noh<CR>", { desc = "Clear highlights" })
map("n", "<leader><leader>", "<cmd>so<CR>", { desc = "Source buffer" })
map("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
      { desc = "Global replace current word" })
map("n", "<leader>j", "<cmd>cnext<CR>zz", { desc = "Next QuickFix" })
map("n", "<leader>k", "<cmd>cprev<CR>zz", { desc = "Previous QuickFix" })
map("n", "<leader>ss", "<cmd>setlocal spell!<CR>", { desc = "Toggle spelling" })
map("n", "<leader>sn", "]s", { desc = "Next spelling error" })
map("n", "<leader>sp", "[s", { desc = "Previous spelling error" })
map("n", "<leader>s?", "z=", { desc = "Suggest spelling" })
map("n", "<leader>sa", "zg", { desc = "Add spelling to directory" })
map("n", "<leader>ww", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })
map("n", "<leader>xt", "<cmd>!trim %<CR>", { desc = "Trim file",
      silent = true })
map("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { desc = "Make file executable",
      silent = true })
-- map("n", ";", ":", { desc = "Enter command mode", nowait = true })
map("n", ".", "mz.`z", { desc = "Repeat last change" }) -- Make '.' not move
map("n", "Q", "gqap", { desc = "Hard re-wrap paragraph" })
map("n", "S", ":%s///gI<Left><Left><Left><Left>", { desc = "Substitution" })
map("n", "Y", "y$", { desc = "Yank to EOL" })
map("n", "p", "]p", { desc = "Paste" })
  -- Edit NeoVim config
map("n", "<leader>nc",
      "<cmd>badd ~/.config/nvim/lua/chadrc.lua<CR><cmd>blast<CR>",
      { desc = "Edit neovim chadrc" })
map("n", "<leader>ni",
      "<cmd>badd ~/.config/nvim/lua/options.lua<CR><cmd>blast<CR>",
      { desc = "Edit neovim init" })
map("n", "<leader>nl",
      "<cmd>badd ~/.config/nvim/lua/configs/lspconfig.lua<CR><cmd>blast<CR>",
      { desc = "Edit neovim LSP config" })
map("n", "<leader>nm",
      "<cmd>badd ~/.config/nvim/lua/mappings.lua<CR><cmd>blast<CR>",
      { desc = "Edit neovim mappings" })
map("n", "<leader>np",
      "<cmd>badd ~/.config/nvim/lua/plugins/init.lua<CR><cmd>blast<CR>",
      { desc = "Edit neovim plugins" })
  -- Folding
map("n", "<leader>f", "zi", { desc = "Toggle folding" })
map("n", "<leader>fd", function ()
    vim.opt.foldclose = "all"
    vim.opt.foldcolumn = 1
    vim.opt.foldmethod = "diff"
    vim.opt.foldenable = true
  end, { desc = "Fold by diff" })
map("n", "<leader>fi", function ()
    vim.opt.foldclose = "all"
    vim.opt.foldcolumn = 1
    vim.opt.foldmethod = "indent"
    vim.opt.foldenable = true
  end, { desc = "Fold by indent" })
map("n", "<leader>fs", function ()
    vim.opt.foldclose = "all"
    vim.opt.foldcolumn = 1
    vim.cmd("syn region myFold start='{' end='}' transparent fold")
    vim.cmd("syn sync fromstart")
    vim.opt.foldmethod = "syntax"
    vim.opt.foldenable = true
  end, { desc = "Fold by syntax" })
map("n", "<leader>ft", "Vatzf", { desc = "Fold by tags" })
map("n", "<leader>M", "zM", { desc = "Close all folds" })
map("n", "<leader>m", "zMzv", { desc = "Close folds, except current" })
map("n", "<leader>o", "zO", { desc = "Open all folds under cursor" })

-- Normal & Terminal Modes
map({ "n", "t" }, "<A-i>", function()
    require("nvchad.term").toggle { pos = "float", id = "floatTerm",
          float_opts={ row = 0.1, col = 0.05, width = 0.9, height = 0.7 }, }
  end, { desc = "Terminal Toggle Floating term" })

-- Normal & Visual (only) Modes
map({ "n", "x" }, "<leader>d", [["_d]],
      { desc = "Delete (don't stomp clipboard)" })
map({ "n", "x" }, "&", "<cmd>&&<CR>", { desc = "Repeat last substitution" })

-- Visual (and Select) Mode
map("v", "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("v", ">", ">gv", { desc = "Indent" })
map("v", "<", "<gv", { desc = "Outdent" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highligeted lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highligeted lines up" })
map("v", "S", ":s///gI<Left><Left><Left><Left>", { desc = "Substitution" })

-- Visual (only) Mode
map("x", "<leader>p", [["_dP]], { desc = "Paste (don't stomp clipboard)" })