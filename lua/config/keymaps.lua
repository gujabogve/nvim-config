-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

map("n", "<leader>ba", ":bufdo bdelete<CR>", { desc = "Close All Buffers" })

vim.keymap.set("n", "<leader>dc", ":DiffClipboard<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>dq", ":CloseDiff<CR>", { noremap = true, silent = true })
