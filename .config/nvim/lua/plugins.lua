require('packer').startup(function(use)
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
          navic = {
            enabled = true,
          },
          noice = true,
        },
      })
    end,
  }
  use {
    'folke/noice.nvim',
    requires = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        presets = {
          lsp_doc_border = true,
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
  use 'hrsh7th/nvim-cmp'
  use 'neovim/nvim-lspconfig'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
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
  }
  use { 'nvim-telescope/telescope-file-browser.nvim' }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'go',
          'lua',
          'vim',
          'markdown',
          'markdown_inline',
          'regex',
          'bash',
        },
        highlight = {
          enable = true,
        },
      })
    end,
  }
  use 'onsails/lspkind.nvim'
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
end)


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
    group = vim.api.nvim_create_augroup('FormatGopls', { clear = true }),
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ async = false })
      vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' }}, apply = true })
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

local tele_builtin = require('telescope.builtin')
local keymap_opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>f', tele_builtin.find_files, keymap_opts)
vim.keymap.set('n', '<leader>g', tele_builtin.live_grep, keymap_opts)
vim.keymap.set('n', '<leader>b', tele_builtin.buffers, keymap_opts)
vim.keymap.set('n', '<leader>c', tele_builtin.commands, keymap_opts)
require('telescope').load_extension('file_browser')
vim.keymap.set('n', '<leader>b', require('telescope').extensions.file_browser.file_browser, keymap_opts)
require('telescope').load_extension('noice')

local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup({
  mapping = cmp.mapping.preset.insert(),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lsp_signature_help' },
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
