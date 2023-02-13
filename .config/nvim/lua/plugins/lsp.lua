return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'j-hui/fidget.nvim',
      'SmiteshP/nvim-navic',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
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
    'j-hui/fidget.nvim',
    lazy = true,
    opts = {
      window = {
        blend = 0,
      },
    },
  },
  {
    'williamboman/mason.nvim',
    lazy = true,
    config = true,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    lazy = true,
    config = true,
  },
}
