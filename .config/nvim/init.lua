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

require('plugins')

local group = vim.api.nvim_create_augroup('init', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = { 'plugins.lua' },
  callback = function()
    vim.cmd [[source <afile> | PackerCompile]]
  end,
})

vim.cmd.colorscheme 'catppuccin-frappe'
