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
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'SmiteshP/nvim-navic',
    },
    opts = function ()
      local navic = require('nvim-navic')
      return {
        options = {
          theme = 'catppuccin',
        },
        sections = {
          lualine_c = {
            { 'filename', path = 1 },
            { navic.get_location, cond = navic.is_available },
          },
        },
      }
    end
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
    'SmiteshP/nvim-navic',
    lazy = true,
    opts = {
      highlight = true,
      depth_limit = 3,
    }
  },
}
