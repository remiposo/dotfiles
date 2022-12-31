-- vi: set ft=lua :

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
local keymap_opts = { noremap=true, silent=true }
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
  use 'neovim/nvim-lspconfig'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use 'wbthomason/packer.nvim'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
end)

require('catppuccin').setup({
  flavour = 'frappe',
})

vim.cmd('colorscheme catppuccin')

require('lualine').setup({
  options = {
    theme = 'catppuccin',
  },
})

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'go',
    'lua',
  },
  highlight = {
    enable = true,
  },
})

require('mason').setup()
require('mason-lspconfig').setup()

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
      vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' }}, apply = true})
    end
  })
end

require('lspconfig')['gopls'].setup({
    on_attach = on_attach_gopls,
    flags = lsp_flags,
})
