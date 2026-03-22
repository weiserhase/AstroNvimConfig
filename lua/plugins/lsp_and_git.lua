---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers = require("astrocore").list_insert_unique(opts.servers, {
        "pyright",
        "leanls",
        "idris2_lsp",
        "clangd", -- use clangd for CUDA files
        "tinymist",
      })

      opts.mappings = opts.mappings or {}
      opts.mappings.n = opts.mappings.n or {}
      opts.mappings.n.gd = {
        function() vim.lsp.buf.definition() end,
        desc = "LSP definition",
        cond = "textDocument/definition",
      }
      opts.mappings.n.gr = {
        function() vim.lsp.buf.references() end,
        desc = "LSP references",
        cond = "textDocument/references",
      }
      opts.mappings.n.gi = {
        function() vim.lsp.buf.implementation() end,
        desc = "LSP implementation",
        cond = "textDocument/implementation",
      }

      opts.config = opts.config or {}
      opts.config.pyright = opts.config.pyright or {}
      opts.config.pyright.settings = opts.config.pyright.settings or {}
      opts.config.pyright.settings.python = vim.tbl_deep_extend("force", opts.config.pyright.settings.python or {}, {
        venvPath = ".",
        venv = ".venv",
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "pyright",
        "black",
        "flake8",
        "clangd",
        "tinymist",
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    opts = function(_, opts)
      local null_ls = require "null-ls"
      opts.sources = opts.sources or {}
      opts.sources = require("astrocore").list_insert_unique(opts.sources, {
        null_ls.builtins.formatting.black.with {
          prefer_local = ".venv/bin",
        },
        require("none-ls.diagnostics.flake8").with {
          prefer_local = ".venv/bin",
        },
      })
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      opts.mappings = opts.mappings or {}
      opts.mappings.n = opts.mappings.n or {}
      opts.mappings.n["<Leader>j"] = { "<C-o>", desc = "Jump back" }
      opts.mappings.n["<Leader>k"] = { "<C-i>", desc = "Jump forward" }
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
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = {
        ["*"] = true,
        markdown = true,
        help = true,
      }

      vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        silent = true,
        desc = "Copilot accept",
      })
      vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Copilot next" })
      vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Copilot previous" })
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Copilot dismiss" })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files (Telescope)" },
      {
        "<Leader>fF",
        function()
          require("telescope.builtin").find_files {
            hidden = true,
            no_ignore = true,
            no_ignore_parent = true,
            follow = true,
          }
        end,
        desc = "Find files (all incl. ignored)",
      },
      {
        "<Leader>fI",
        function()
          require("telescope.builtin").find_files {
            find_command = {
              "sh",
              "-c",
              "git ls-files --others -i --exclude-standard | grep -Ev '^(\\.git/|\\.venv/|venv/|node_modules/|\\.mypy_cache/|\\.pytest_cache/)'",
            },
          }
        end,
        desc = "Find files (ignored only, filtered)",
      },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Live grep (Telescope)" },
      {
        "<Leader>fG",
        function()
          require("telescope.builtin").live_grep {
            additional_args = function()
              return {
                "--hidden",
                "--no-ignore",
                "--glob",
                "!.git/*",
                "--glob",
                "!.venv/*",
                "--glob",
                "!venv/*",
                "--glob",
                "!node_modules/*",
              }
            end,
          }
        end,
        desc = "Live grep (all incl. ignored, filtered)",
      },
      {
        "<Leader>fJ",
        function()
          local ignored_files = vim.fn.systemlist("git ls-files --others -i --exclude-standard")
          if vim.v.shell_error ~= 0 then
            vim.notify("Not in a git repository", vim.log.levels.WARN)
            return
          end
          if #ignored_files == 0 then
            vim.notify("No ignored files found", vim.log.levels.INFO)
            return
          end

          local filtered = {}
          for _, file in ipairs(ignored_files) do
            if not file:match "^%.git/" and not file:match "^%.venv/" and not file:match "^venv/" and not file:match "^node_modules/" and not file:match "^%.mypy_cache/" and not file:match "^%.pytest_cache/" then
              table.insert(filtered, file)
            end
          end

          if #filtered == 0 then
            vim.notify("No ignored files found after filtering", vim.log.levels.INFO)
            return
          end

          require("telescope.builtin").live_grep {
            search_dirs = filtered,
            additional_args = function() return { "--hidden", "--no-ignore", "--glob", "!.git/*" } end,
          }
        end,
        desc = "Live grep (ignored only, filtered)",
      },
      { "<Leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Buffers (Telescope)" },
      { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Help tags (Telescope)" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
      },
    },
  },
}
