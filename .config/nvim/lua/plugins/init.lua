return {
  {
    'j-hui/fidget.nvim',
    config = function ()
      require('fidget').setup({
        window = {
          blend = 0,
        },
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup()

      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, bufnr)
        end
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, bufopts)
      end

      local lsp_flags = {
        debounce_text_changes = 150,
      }

      local on_attach_gopls = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function()
            -- auto import using lsp's codeAction
            local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
            params.context = { only = { 'source.organizeImports' }}
            local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
            for _, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
                else
                  vim.lsp.buf.execute_command(r.command)
                end
              end
            end
            -- auto format
            vim.lsp.buf.format({ async = false })
          end
        })
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require('lspconfig')['gopls'].setup({
        on_attach = on_attach_gopls,
        flags = lsp_flags,
        capabilities = capabilities,
      })
      require('lspconfig')['lua_ls'].setup({
        on_attach = on_attach,
        flags = lsp_flags,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
        capabilities = capabilities,
      })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local navic = require('nvim-navic')
      require('lualine').setup({
        options = {
          theme = 'catppuccin',
        },
        sections = {
          lualine_c = {
            { 'filename', path = 1 },
            { navic.get_location, cond = navic.is_available },
          },
        },
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local tele_builtin = require('telescope.builtin')
      local keymap_opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>f', tele_builtin.find_files, keymap_opts)
      vim.keymap.set('n', '<leader>g', tele_builtin.live_grep, keymap_opts)
      vim.keymap.set('n', '<leader>b', tele_builtin.buffers, keymap_opts)
      vim.keymap.set('n', '<leader>c', tele_builtin.commands, keymap_opts)
      require('telescope').load_extension('file_browser')
      vim.keymap.set('n', '<leader>n', require('telescope').extensions.file_browser.file_browser, keymap_opts)
    end,
  },
  { 'nvim-telescope/telescope-file-browser.nvim' },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    'SmiteshP/nvim-navic',
    config = function()
      require('nvim-navic').setup({
        highlight = true,
        depth_limit = 3,
      })
    end
  },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  },
}
