return {
    'tpope/vim-fugitive', version = '*',
    config = function() 
	-- Set a keybind for the main Git status window
        -- This is the "hub" for staging, committing, and pushing
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status" })
        -- Optional: Add more specific shortcuts if you like
        vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git Push" })
        vim.keymap.set("n", "<leader>gl", ":Git pull<CR>", { desc = "Git Pull" })
    end,
}
