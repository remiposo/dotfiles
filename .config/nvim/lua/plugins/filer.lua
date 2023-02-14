return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = true,
    branch = 'v2.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    init = function ()
      local keymap_opts = { noremap = true, silent = true }

      vim.keymap.set('n', '<C-n>', function ()
        require('neo-tree.command').execute({ position = 'float', toggle = true, reveal = true })
      end, keymap_opts)
    end
  },
}
