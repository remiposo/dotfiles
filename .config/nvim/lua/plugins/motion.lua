return {
  {
    'phaazon/hop.nvim',
    version = '2.*',
    lazy = true,
    init = function ()
      local function hint_char1(direction, offset)
        return function ()
          require('hop').hint_char1({
            direction = require('hop.hint').HintDirection[direction],
            hint_offset = offset,
          })
        end
      end
      local keymap_opts = { noremap = true, silent = true }

      vim.keymap.set('n', 'f', hint_char1('AFTER_CURSOR', 0), keymap_opts)
      vim.keymap.set('n', 'F', hint_char1('BEFORE_CURSOR', 0), keymap_opts)
      vim.keymap.set('n', 't', hint_char1('AFTER_CURSOR', -1), keymap_opts)
      vim.keymap.set('n', 'T', hint_char1('BEFORE_CURSOR', 1), keymap_opts)
    end,
    config = true,
  },
}
