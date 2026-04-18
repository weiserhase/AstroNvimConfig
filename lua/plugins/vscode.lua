if not vim.g.vscode then return {} end

local plugins = {
  "lazy.nvim",
  "AstroNvim",
  "astrocore",
  "astroui",
  "nvim-autopairs",
  "nvim-treesitter",
  "nvim-ts-autotag",
  "nvim-treesitter-textobjects",

  -- your extra non-visual plugins
  "leap.nvim",
  "vim-repeat",
  "nvim-surround",
  "Comment.nvim",
}

local Config = require "lazy.core.config"

Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin) return vim.tbl_contains(plugins, plugin.name) end

return {
  {
    "AstroNvim/astrocore",
    opts = {
      treesitter = {
        highlight = false,
      },
    },
  },
  { "AstroNvim/astroui", opts = { colorscheme = false } },
}
