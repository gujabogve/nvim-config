-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

map("n", "<leader>ba", ":bufdo bdelete<CR>", { desc = "Close All Buffers" })

local diff = require("config.diff")
vim.keymap.set("n", "<leader>dc", diff.diff_clipboard, { noremap = true, silent = true, desc = "Diff Clipboard" })
vim.keymap.set("n", "<leader>db", diff.diff_branch, { noremap = true, silent = true, desc = "Diff Branch" })
vim.keymap.set("n", "<leader>dq", diff.close_diff, { noremap = true, silent = true, desc = "Close Diff" })
