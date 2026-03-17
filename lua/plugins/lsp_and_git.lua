---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers = require("astrocore").list_insert_unique(opts.servers, {
        "leanls",
        "idris2_lsp",
        "clangd", -- use clangd for CUDA files
        "tinymist",
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "clangd",
        "tinymist",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "typst",
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<Leader>gs", "<Cmd>Git<CR>", desc = "Git status (Fugitive)" },
      { "<Leader>gd", "<Cmd>Gdiffsplit<CR>", desc = "Git diff split (Fugitive)" },
      { "<Leader>gb", "<Cmd>Git blame<CR>", desc = "Git blame (Fugitive)" },
      { "<Leader>gl", "<Cmd>Git log --oneline --decorate --graph<CR>", desc = "Git log (Fugitive)" },
      { "<Leader>gp", "<Cmd>Git push<CR>", desc = "Git push (Fugitive)" },
      { "<Leader>gP", "<Cmd>Git pull<CR>", desc = "Git pull (Fugitive)" },
      { "<Leader>gw", "<Cmd>Gwrite<CR>", desc = "Git add current file (Fugitive)" },
      { "<Leader>gr", "<Cmd>Gread<CR>", desc = "Git checkout current file (Fugitive)" },
      { "<Leader>gc", "<Cmd>Git commit<CR>", desc = "Git commit (Fugitive)" },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      local leap = require "leap"

      -- Local-window leaps on s/S, with global-window variants on gs/gS.
      vim.keymap.set({ "n", "x", "o" }, "s", function()
        leap.leap { target_windows = { vim.api.nvim_get_current_win() } }
      end, { desc = "Leap forward" })
      vim.keymap.set({ "n", "x", "o" }, "S", function()
        leap.leap { backward = true, target_windows = { vim.api.nvim_get_current_win() } }
      end, { desc = "Leap backward" })
      vim.keymap.set({ "n", "x", "o" }, "gs", function() leap.leap {} end, { desc = "Leap forward (all windows)" })
      vim.keymap.set({ "n", "x", "o" }, "gS", function() leap.leap { backward = true } end, { desc = "Leap backward (all windows)" })
    end,
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {},
    cmd = { "TypstPreview", "TypstPreviewStop", "TypstPreviewToggle" },
  },
}
