-- git clone --depth 1 https://github.com/NvChad/NvChad ~/.config/nvim && nvim
vim.opt.colorcolumn = "+1" -- Color wide columns
vim.opt.autochdir = true -- Use documents directory for PWD
vim.opt.autoindent = true -- Control indenting
vim.opt.autoread = true -- Set to auto read/write
vim.opt.autowrite = true
vim.opt.backspace = "indent,eol,start" -- Allow backspacing over everything
vim.opt.backup = false -- Turn backup off
vim.opt.wb = false
vim.opt.swapfile = false
vim.opt.clipboard:remove { "unnamedplus" } -- Don't copy to system clipboard
vim.opt.diffopt:append { "iwhite", "linematch:60" } -- Fix line changes "icase"
vim.opt.eol = false -- Sane text encoding
vim.opt.fixeol = false
vim.opt.errorbells = false -- Control error beep/flash
vim.opt.visualbell = true
vim.opt.fileformats = "unix,mac,dos"
vim.opt.history = 50 -- Keep 50 lines of command line history
vim.opt.ignorecase = true -- Do smart case insensitive matching
vim.opt.incsearch = true
vim.opt.magic = true
vim.opt.smartcase = true
vim.opt.laststatus = 2 -- Show status w/ position and set title
vim.opt.showmode = false
vim.opt.ruler = true
vim.opt.title = true
vim.opt.lazyredraw = true -- Handle drawing better
vim.opt.nrformats:remove { "octal" } -- Remove useless format
vim.opt.ttyfast = true
vim.opt.scrolloff = 2 -- Show context around the cursor
vim.opt.sidescrolloff = 5
vim.opt.secure = true -- Prevent sourced configs from running
vim.opt.shiftround = true -- Control tabs
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shortmess = "aIoOtT" -- Avoid the Hit ENTER prompt
vim.opt.showcmd = true -- Display incomplete commands
vim.opt.showmatch = true -- Show matching for "mat" .1 of a second
vim.opt.mat = 2
vim.opt.textwidth = 80 -- Control line wrapping; textwidth & formatoptions
vim.opt.fo:remove { "t", "c" }
vim.opt.fo:append { "r", "n" }
vim.opt.timeout = true -- Set maps timeout length
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 300
-- Declutter the home directory
vim.opt.viminfo = "h,'50,<1000,s1000,/100,:100,n~/.config/nvim/nviminfo"
vim.opt.inccommand = "split"
vim.opt.hlsearch = true
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")
vim.opt.mouse = ""
vim.opt.mousehide = true
vim.opt.spelllang = "en_us"
vim.opt_local.spell = true
vim.opt.guifont = 'MonaspiceKr Nerd Font Regular 11' -- Set the font

-- Ignore a long shift press
vim.cmd("cab Q q")
vim.cmd("cab Q! q!")
vim.cmd("cab W! w!")
vim.cmd("cab W!! w!!")
vim.cmd("cab WQ wq")
vim.cmd("cab Wq wq")

local augroup = vim.api.nvim_create_augroup("user", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufWritePre" }, {
  desc = "Clean garbage trailing whitespace", group = augroup,
  pattern = "*",
  command = "if ! &bin | silent! %s/\\s\\+$//ge | endif"
})
vim.api.nvim_create_autocmd("TabEnter", {
  desc = "Get filetype if not set", group = augroup,
  pattern = "*",
  command = "windo if &ft == '' | filetype detect | endif"
})
vim.api.nvim_create_autocmd("VimResized", {
  desc = "Auto resize panes when resizing nvim window", group = augroup,
  pattern = "*",
  command = "tabdo wincmd =",
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  desc = "Set filetype for justfiles", group = augroup,
  pattern = { "*justfile", "*.just" },
  command = "setfiletype just",
})
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Check justfile format on save", group = augroup,
  pattern = { "*justfile", "*.just" },
  command = "!just --unstable --fmt --check --justfile '%'",
})
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text", group = augroup,
  callback = function() vim.highlight.on_yank() end,
})
-- vim.api.nvim_create_autocmd({ "BufReadPost","TextChanged","TextChangedI" },{
--   desc = "Show column only if a line is too long", group = augroup,
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

if vim.wo.diff then
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    group = augroup,
    command = "diffupdate"
  }) -- In diff, auto-update
  vim.cmd("cab q qa")
  require("core.utils").load_mappings("diff")
  vim.opt.diffexpr = ""
end -- &diff