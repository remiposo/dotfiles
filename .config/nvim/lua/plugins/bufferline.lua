return {
  'akinsho/bufferline.nvim',
  version = '3.*',
  dependencies = {
    'catppuccin',
    'nvim-tree/nvim-web-devicons',
  },
  opts = function ()
    return {
      highlights = require('catppuccin.groups.integrations.bufferline').get(),
    }
  end,
  config = function(_, opts)
    require("bufferline").setup(opts)

    local keymap_opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'qn', ':BufferLineCycleNext<CR>', keymap_opts)
    vim.keymap.set('n', 'qp', ':BufferLineCyclePrev<CR>', keymap_opts)
    vim.keymap.set('n', 'qd', ':bdelete<CR>', keymap_opts)
    vim.keymap.set('n', 'qD', ':BufferLineCloseRight<CR>', keymap_opts)
  end
}
