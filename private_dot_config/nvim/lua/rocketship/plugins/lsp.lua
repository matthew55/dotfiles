return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { 
          "html", "cssls", "jdtls", "ts_ls", 
          "pyright", "clangd", "rust_analyzer" 
        },
      })

      -- The Modern Neovim 0.11+ Way
      local servers = { 
        html = {}, 
        cssls = {}, 
        jdtls = {}, 
        ts_ls = {}, 
        pyright = {}, 
        clangd = {}, 
        rust_analyzer = {} 
      }

      for server, config in pairs(servers) do
        -- Use the native Neovim config API
        vim.lsp.config(server, config)
        -- Enable the server globally or per-buffer
        vim.lsp.enable(server)
      end

      -- Modern Diagnostic Config
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
      })

      -- Native Keybindings
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },
  -- 2. Autocomplete Engine (The Dropdown)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Connects LSP to the menu
      "hrsh7th/cmp-buffer",   -- Adds words from your current file to the menu
      "hrsh7th/cmp-path",     -- Adds file system paths to the menu
      "L3MON4D3/LuaSnip",     -- Snippet engine
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        -- The "Visuals" of the menu
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(), -- Force open the menu
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept the suggestion
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        -- THE MOST IMPORTANT PART:
        sources = cmp.config.sources({
          { name = 'nvim_lsp' }, -- Show LSP suggestions (the primary source)
          { name = 'luasnip' },  -- Show snippets
          { name = 'buffer' },   -- Suggest words from the current file
          { name = 'path' },     -- Suggest file paths
        })
      })
    end,
  }
}
