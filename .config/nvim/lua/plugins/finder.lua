return {
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.*',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    init = function()
      local function builtin(name)
        return function()
          return require('telescope.builtin')[name]()
        end
      end
      local keymap_opts = { noremap = true, silent = true }

      vim.keymap.set('n', '<leader>f', builtin('find_files'), keymap_opts)
      vim.keymap.set('n', '<leader>g', builtin('live_grep'), keymap_opts)
      vim.keymap.set('n', '<leader>b', builtin('buffers'), keymap_opts)
      vim.keymap.set('n', '<leader>c', builtin('commands'), keymap_opts)
    end,
  },
}
