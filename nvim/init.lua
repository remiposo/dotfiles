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
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gk', 'k')
vim.keymap.set('n', 'q', '<Nop>')
vim.keymap.set('n', '<C-a>', '^')
vim.keymap.set('n', '<C-e>', '$')
vim.keymap.set('n', '<ESC><ESC>', ':nohlsearch<CR>')
vim.keymap.set('n', '<Space>', '<C-w>w')
vim.keymap.set('n', 's', '<Nop>')
vim.keymap.set('n', 'sh', '<C-w>h')
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sl', '<C-w>l')
-- transfer yanked to clipper runnning on localhost:8377
vim.keymap.set('n', '<leader>y', ':call system("nc -c localhost 8377", @0)<CR>')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-l>', '<Right>')
vim.keymap.set('c', '<C-p>', '<Up>')
vim.keymap.set('c', '<C-n>', '<Down>')

-- #----------------------------------------------#
-- # plugins                                      #
-- #----------------------------------------------#
require('packer').startup(function(use)
  use "EdenEast/nightfox.nvim"
  use 'folke/tokyonight.nvim'
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

require('nightfox').setup({
  options = {
    dim_inactive = true,
  },
})

--require('tokyonight').setup({
--  style = 'moon',
--  dim_inactive = true,
--  lualine_bold = true,
--})

vim.cmd('colorscheme nordfox')

require('lualine').setup()

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
require("mason-lspconfig").setup()

local opts = { noremap=true, silent=true }
vim.keymap.set('n', 'gp', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', 'gn', vim.diagnostic.goto_next, opts)

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
      vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' }}, apply = true})
      vim.lsp.buf.formatting_seq_sync()
    end
  })
end

require('lspconfig')['gopls'].setup({
    on_attach = on_attach_gopls,
    flags = lsp_flags,
})
