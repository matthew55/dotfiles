return {
    'mbbill/undotree', version = '*',
    lazy = false,
    build = ':TSUpdate',
    config = function() 
        require('nvim-treesitter').setup({
	})
	vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end,
}
