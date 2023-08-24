local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("lazy").setup("plugins")

vim.opt.shortmess = vim.opt.shortmess + { I = true }
vim.opt.listchars = {
  tab = ">·",
  trail = "·",
  extends = "»",
  precedes = "«",
  eol = "⏎",
}
vim.opt.list = true
vim.opt.relativenumber = true

vim.wo.number = true
vim.wo.signcolumn = 'yes'

vim.o.mouse = 'a'
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.termguicolors = true
vim.o.completeopt = 'menuone'
vim.o.scrolloff = 5
