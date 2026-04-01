return {
    'catgoose/nvim-colorizer.lua', version = '*',
    event = "BufReadPre",
    opts = {},
    config = function() 
        require('colorizer').setup({
            options = { parsers = { css = true } },
	})
    end,
}
