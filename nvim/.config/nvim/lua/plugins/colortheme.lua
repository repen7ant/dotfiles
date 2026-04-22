return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true, -- Enable global transparency
    styles = {
      sidebars = 'transparent', -- Ensure Neo-tree remains transparent
      floats = 'transparent', -- Optional: makes floating windows transparent
    },
  },
  config = function(_, opts)
    require('kanagawa').setup(opts)
    vim.cmd [[colorscheme kanagawa]]
  end,
}
