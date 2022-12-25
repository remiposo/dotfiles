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
vim.keymap.set('n', 's', '<Nop>')
vim.keymap.set('n', 'ss', ':split<Return><C-w>w')
vim.keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
vim.keymap.set('n', '<Space>', '<C-w>w')
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
  use 'wbthomason/packer.nvim'
  use 'EdenEast/nightfox.nvim'
end)

require('nightfox').setup({
  options = {
    transparent = true,
  },
})
vim.cmd('colorscheme nordfox')
