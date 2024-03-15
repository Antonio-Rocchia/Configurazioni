vim.g.mapleader = " "
vim.g.editorconfig = true

local opt = vim.opt

vim.cmd.colorscheme("habamax")

opt.autowrite = true
opt.wildmode = "longest:full,full"
opt.splitbelow = true
opt.splitright = true
opt.shortmess:append({ W = true, I = true, c = true })
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.timeoutlen = 500

-- System integration
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Editing
opt.expandtab = true -- space instead of tab
opt.tabstop = 2 -- visually how many spaces represent a tab
opt.shiftwidth = 0 -- when 0 is equal to tabstop
opt.wrap = false
opt.smartindent = true

opt.undofile = true
opt.backup = false
opt.swapfile = false
opt.undolevels = 10000

opt.updatetime = 200
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- Search releated
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.smartcase = true

-- Look
opt.completeopt = "menu,menuone,preview,noselect"
opt.pumblend = 10
opt.pumheight = 10
opt.scrolloff = 4
opt.number = true
opt.relativenumber = true
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false

-- Diagnostic
vim.diagnostic.config({
  -- update_in_insert = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
