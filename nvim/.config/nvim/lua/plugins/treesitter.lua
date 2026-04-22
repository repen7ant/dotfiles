return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      ensure_installed = {
        'bash',
        'c',
        'html',
        'lua',
        'query',
        'vim',
        'css',
        'java',
        'python',
        'toml',
        'yaml',
        'sql',
        'php',
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
    }
  end,
}
