require("rocketship.remap")
require("rocketship.lazy")

-- Add comments
vim.keymap.set('n', '<C-/>', 'gcc', { remap = true })
vim.keymap.set('v', '<C-/>', 'gc', { remap = true })

-- Setup interacting with system clipboard 
-- Yank to system clipboard using <Leader>y
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- Yank entire line to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- Paste from system clipboard using <Leader>p
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]])

-- Show line numbers
-- Show standard line numbers
vim.opt.number = true
-- Show relative line numbers (highly recommended for Neovim)
vim.opt.relativenumber = true
