-- #----------------------------------------------#
-- # common variables                             #
-- #----------------------------------------------#
vim.g.mapleader = ','

-- #----------------------------------------------#
-- # common options                               #
-- #----------------------------------------------#
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true

-- #----------------------------------------------#
-- # common keymaps                               #
-- #----------------------------------------------#
local keymap_opts = { noremap = true, silent = true }
vim.keymap.set('n', 'j', 'gj', keymap_opts)
vim.keymap.set('n', 'gj', 'j', keymap_opts)
vim.keymap.set('n', 'k', 'gk', keymap_opts)
vim.keymap.set('n', 'gk', 'k', keymap_opts)
vim.keymap.set('n', 'q', '<Nop>', keymap_opts)
vim.keymap.set('n', '<C-a>', '^', keymap_opts)
vim.keymap.set('n', '<C-e>', '$', keymap_opts)
vim.keymap.set('n', '<ESC><ESC>', ':nohlsearch<CR>', keymap_opts)
vim.keymap.set('n', '<Space>', '<C-w>w', keymap_opts)
vim.keymap.set('n', 's', '<Nop>', keymap_opts)
vim.keymap.set('n', 'sh', '<C-w>h', keymap_opts)
vim.keymap.set('n', 'sj', '<C-w>j', keymap_opts)
vim.keymap.set('n', 'sk', '<C-w>k', keymap_opts)
vim.keymap.set('n', 'sl', '<C-w>l', keymap_opts)
-- transfer yanked to clipper runnning on localhost:8377
vim.keymap.set('n', '<leader>y', ':call system("nc -c localhost 8377", @0)<CR>', keymap_opts)
vim.keymap.set('i', '<C-h>', '<Left>', keymap_opts)
vim.keymap.set('i', '<C-j>', '<Down>', keymap_opts)
vim.keymap.set('i', '<C-k>', '<Up>', keymap_opts)
vim.keymap.set('i', '<C-l>', '<Right>', keymap_opts)
vim.keymap.set('c', '<C-p>', '<Up>', keymap_opts)
vim.keymap.set('c', '<C-n>', '<Down>', keymap_opts)
vim.keymap.set('n', 'gp', vim.diagnostic.goto_prev, keymap_opts)
vim.keymap.set('n', 'gn', vim.diagnostic.goto_next, keymap_opts)

-- #----------------------------------------------#
-- # plugins                                      #
-- #----------------------------------------------#
require('packer').startup(function(use)
  use { 'catppuccin/nvim', as = 'catppuccin' }
  use {
    'folke/noice.nvim',
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
    requires = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
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
  }
  use 'onsails/lspkind.nvim'
  use 'p00f/nvim-ts-rainbow'
  use 'SmiteshP/nvim-navic'
  use 'wbthomason/packer.nvim'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
end)

require('catppuccin').setup({
  flavour = 'frappe',
  dim_inactive = {
    enabled = true,
  },
  integrations = {
    ts_rainbow = true,
    navic = {
      enabled = true,
    },
    noice = true,
  },
})

vim.cmd('colorscheme catppuccin')

local navic = require('nvim-navic')
navic.setup({
  highlight = true,
  depth_limit = 3,
})

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
  rainbow = {
    enable = true,
    extended_mode = true,
  },
})

require('mason').setup()
require('mason-lspconfig').setup()

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
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
