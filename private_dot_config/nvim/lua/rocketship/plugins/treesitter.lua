return {
    'nvim-treesitter/nvim-treesitter', version = '*',
    lazy = false,
    build = ':TSUpdate',
    config = function() 
        require('nvim-treesitter').setup({
	    ensure_installed = { "help", "java", "lua", "vim", "vimdoc", "javascript", "typescript", "python", "html", "css", "c", "cpp", "rst" },
	    sync_install = false,
	    highlight = { enable = true }, 
	    indent = { enable = true },
	})
    end,
}
