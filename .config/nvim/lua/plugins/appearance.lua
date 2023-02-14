return {
  {
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
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = true,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = true,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      options = {
        theme = 'catppuccin',
      },
    },
  },
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
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      theme = 'catppuccin',
    },
  },
}
