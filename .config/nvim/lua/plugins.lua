require('packer').startup(function(use)
  use {
    'akinsho/bufferline.nvim',
    tag = 'v3.*',
    after = 'catppuccin',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function ()
      require("bufferline").setup({
        highlights = require("catppuccin.groups.integrations.bufferline").get()
      })
      local keymap_opts = { noremap = true, silent = true }
      vim.keymap.set('n', 'qn', ':BufferLineCycleNext<CR>', keymap_opts)
      vim.keymap.set('n', 'qp', ':BufferLineCyclePrev<CR>', keymap_opts)
      vim.keymap.set('n', 'qw', ':BufferLinePick<CR>', keymap_opts)
      vim.keymap.set('n', 'qd', ':BufferLinePickClose<CR>', keymap_opts)
    end
  }
  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'frappe',
        dim_inactive = {
          enabled = true,
        },
        integrations = {
          fidget = true,
          navic = {
            enabled = true,
          },
        },
      })
    end,
  }
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lsp-document-symbol'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-path'
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'luasnip' },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            menu = ({
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              path = '[Path]',
            }),
          }),
        },
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp_document_symbol' },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' },
            },
          },
        }),
      })
    end,
  }
  use {
    'j-hui/fidget.nvim',
    config = function ()
      require('fidget').setup({
        window = {
          blend = 0,
        },
      })
    end
  }
  use {
    'L3MON4D3/LuaSnip',
    tag = 'v<CurrentMajor>.*',
  }
  use {
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
      require('lspconfig')['sumneko_lua'].setup({
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
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
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
  }
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { 'nvim-lua/plenary.nvim' },
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
  }
  use { 'nvim-telescope/telescope-file-browser.nvim' }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        highlight = {
          enable = true,
        },
      })
    end,
  }
  use 'onsails/lspkind.nvim'
  use 'saadparwaiz1/cmp_luasnip'
  use {
    'SmiteshP/nvim-navic',
    config = function()
      require('nvim-navic').setup({
        highlight = true,
        depth_limit = 3,
      })
    end
  }
  use 'wbthomason/packer.nvim'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }
end)
