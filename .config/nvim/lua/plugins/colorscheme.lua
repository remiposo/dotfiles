return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = 'frappe',
      integrations = {
        fidget = true,
        navic = {
          enabled = true,
        },
        barbecue = {
          dim_dirname = true,
        },
      },
    })
    vim.cmd([[colorscheme catppuccin]])
  end,
}
