-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Paste from yank register (register 0)
map("n", "P", '"0P', { desc = "Paste last yank before" })
map("v", "p", '"0p', { desc = "Paste last yank" })

-- Better increment/decrement
map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "_", "<C-x>", { desc = "Decrement number" })

-- Delete a word backwards
map("n", "dw", 'vb"_d')

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Duplicate line/selection
map("n", "yd", "yyp", { desc = "Duplicate line" })
map("v", "yd", "y'>p", { desc = "Duplicate selection" })

-- Move window
map("n", "sh", "<C-w>h")
map("n", "sk", "<C-w>k")
map("n", "sj", "<C-w>j")
map("n", "sl", "<C-w>l")

map("n", "<leader>fh", "<cmd>split | terminal<cr>", { desc = "Terminal split" })
map("n", "<leader>fv", "<cmd>vsplit | terminal<cr>", { desc = "Terminal vsplit" })

-- Delete without affecting registers (using <leader>x prefix)
map("n", "x", '"_x', { desc = "Delete char (no register)" })
map("n", "X", '"_X', { desc = "Delete selection (no register)" })

map("n", "dx", '"_dd', { desc = "Delete line (no register)" })
map("v", "x", '"_d', { desc = "Delete selection (no register)" })

-- Change without affecting registers
map("n", "cx", '"_cc', { desc = "Change line (no register)" })
map("n", "cw", '"_cw', { desc = "Change word (no register)" })
map("v", "c", '"_c', { desc = "Change selection (no register)" })

map("n", "D", '"_D', { desc = "Delete to line end (no register)" })
map("n", "C", '"_C', { desc = "Change to line end (no register)" })

-- Better line navigation
map({ "n", "v" }, "H", "^", { desc = "Go to line start" })
map({ "n", "v" }, "L", "$", { desc = "Go to line end" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better search centering
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
