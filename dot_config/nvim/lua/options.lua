require "nvchad.options"

local o = vim.opt
local og = vim.opt_global
local ol = vim.opt_local

-- add yours here!
o.autochdir = true -- Use documents directory for PWD
o.autoindent = true -- Control indenting
o.autoread = true -- Set to auto read/write
o.autowrite = true
o.backspace = "indent,eol,start" -- Allow backspacing over everything
o.backup = false -- Turn backup off
o.writebackup = false
o.swapfile = false
o.clipboard:remove { "unnamedplus" } -- Don't copy to system clipboard
o.completeopt = "menuone,noselect,popup" -- Tame the insane LSP completion
o.diffopt:append { "iwhite", "linematch:60" } -- Fix line changes "icase"
og.eol = false -- Sane text encoding
ol.fixeol = false
o.errorbells = false -- Control error beep/flash
o.visualbell = true
o.fileformats = "unix,mac,dos"
o.history = 50 -- Keep 50 lines of command line history
o.ignorecase = true -- Do smart case insensitive matching
o.incsearch = true
o.magic = true
o.smartcase = true
o.laststatus = 2 -- Show status w/ position and set title
o.showmode = false
o.ruler = true
o.title = true
o.lazyredraw = true -- Handle drawing better
o.nrformats:remove { "octal" } -- Remove useless format
o.ttyfast = true
o.scrolloff = 2 -- Show context around the cursor
o.sidescrolloff = 5
o.secure = true -- Prevent sourced configs from running
o.shiftround = true -- Control tabs
o.expandtab = true
o.smarttab = true
o.shortmess = "aIoOtT" -- Avoid some the Hit ENTER prompt
o.showcmd = true -- Display incomplete commands
o.showmatch = true -- Show matching for "mat" .1 of a second
o.mat = 2
o.textwidth = 80 -- Control line wrapping; textwidth & formatoptions
o.fo:remove { "t", "c" }
o.fo:append { "r", "n" }
o.timeout = true -- Set maps timeout length
o.timeoutlen = 300
o.ttimeoutlen = 300
-- Declutter the home directory
o.viminfo = "h,'50,<1000,s1000,/100,:100,n~/.config/nvim/nviminfo"
o.inccommand = "split"
o.hlsearch = true
o.colorcolumn = "+1" -- Color wide columns
o.cursorcolumn = true
o.cursorline = true
o.cursorlineopt = "both" -- to enable cursorline!
o.undofile = true
o.undodir = vim.fn.expand "~/.config/nvim/undo"
o.mouse = ""
o.mousehide = true
o.spelllang = "en_us"
o.spell = true
if vim.fn.has('macunix') then
  o.guifont = "CaskaydiaCove_NF_Regular:h12" -- Set the font
else
  o.guifont = "MonaspiceKr Nerd Font Regular 11" -- Set the font
end

vim.diagnostic.config({ virtual_text = true })
-- vim.diagnostic.config({ virtual_text = { current_line = true } })

-- Ignore a long shift press
vim.cmd "cab Q q"
vim.cmd "cab Q! q!"
vim.cmd "cab W! w!"
vim.cmd "cab W!! w!!"
vim.cmd "cab WQ wq"
vim.cmd "cab Wq wq"

local augroup = vim.api.nvim_create_augroup("user", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Setup auto completion with LSP when supported", group = augroup,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufWritePre" }, {
  desc = "Clean garbage trailing whitespace", group = augroup, pattern = "*",
  command = "if ! &bin | silent! %s/\\s\\+$//ge | endif",
})
vim.api.nvim_create_autocmd({ "BufEnter", "WinNew" }, {
  desc = "Set options", group = augroup, pattern = "*",
  command = "source ~/.config/nvim/lua/options.lua",
})
vim.api.nvim_create_autocmd("TabEnter", {
  desc = "Get filetype if not set", group = augroup, pattern = "*",
  command = "windo if &ft == '' | filetype detect | endif",
})
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Don't trim EOL for YAML files", group = augroup, pattern = "*",
  command = "windo if &ft == 'yaml' || &ft == 'justfile' | setl fixeol | endif",
})
vim.api.nvim_create_autocmd("VimResized", {
  desc = "Auto resize panes with window", group = augroup, pattern = "*",
  command = "tabdo wincmd =",
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  desc = "Set filetype for justfiles", group = augroup,
  pattern = { "*justfile", "*.just" },
  command = "setfiletype just",
})
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Check justfile format on save", group = augroup,
  pattern = { "*justfile", "*.just" },
  command = "!just --unstable --fmt --check --justfile '%'",
})
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Call formater after writing files", group = augroup, pattern = "*",
  callback = function(args)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
      return
    end
    -- These options will be passed to conform.format()
    require("conform").format { bufnr = args.buf, timeout_ms = 500,
          lsp_format = "fallback", }
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text", group = augroup,
  callback = function() vim.highlight.on_yank() end,
})
vim.api.nvim_create_autocmd("FileType", {
  desc = "Highlight when yanking (copying) text", group = augroup,
  pattern = "yaml.ansible",
  callback = function() vim.keymap.set("n", "<leader>yf",
        "<cmd>set filetype=yaml<CR>", { desc = "Set yaml ft" }) end,
})
-- vim.api.nvim_create_autocmd({ "BufReadPost","TextChanged","TextChangedI" },{
--   desc = "Show column only if a line is too long", group = augroup,
--   group = augroup,
--   pattern = "*",
--   callback = function()
--       -- See https://superuser.com/questions/22444/#1289220
--       local lines = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(),
--             0, -1, true) -- file scope
--       local maxLineLength = vim.fn.max(vim.fn.map(lines, vim.fn.col('$')-1))
--
--       if maxLineLength > vim.opt.textwidth["_value"] then
--         vim.opt.colorcolumn = "+1" -- Color wide columns
--       else
--         vim.opt.colorcolumn = ""
--       end
--     end
-- })

vim.filetype.add({extension = { yml = 'yaml.ansible' }})

if vim.wo.diff then
  require "nvchad.mappings"
  local map = vim.keymap.set
  map("n", "<A-Down>", "do", { desc = "Next diff", silent = true })
  map("n", "<A-Left>", "[c", { desc = "Copy diff left<-right", silent = true })
  map("n", "<A-Right>", "]c", { desc = "Copy diff left->right", silent = true })
  map("n", "<A-Up>", "dp", { desc = "Previous diff", silent = true })
  map("n", "<A-r>", "<cmd>diffupdate<CR>", { desc = "Update diff",
        silent = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    desc = "Update the diff on save", group = augroup, pattern = "*",
    command = "diffupdate",
  }) -- In diff, auto-update
  vim.cmd "cab q qa"
  vim.opt.diffexpr = ""
end -- &diff