-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

opt.shell = "fish"
opt.relativenumber = false 
opt.scrolloff = 10
opt.splitkeep = "cursor"
opt.hlsearch = true

opt.spelllang = { "en", "pt_br" }

opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false

opt.splitbelow = true
opt.splitright = true
opt.fillchars:append({
  foldopen = "",
  foldclose = "",
  fold = " ",
  eob = " ",
})
