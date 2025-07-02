return {
  -- Laravel-specific plugins
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Sail", "Artisan", "Composer" },
    keys = {
      { "<leader>la", ":Artisan<cr>", desc = "Laravel Artisan" },
      { "<leader>lr", ":Artisan route:list<cr>", desc = "Laravel Routes" },
      { "<leader>lm", ":Artisan make:", desc = "Laravel Make" },
    },
  },

  -- PHP Language Support
  {
    "phpactor/phpactor",
    ft = "php",
    build = "composer install --no-dev --optimize-autoloader",
    config = function()
      vim.keymap.set("n", "<Leader>pm", ":PhpactorContextMenu<CR>", { noremap = true, silent = true })
    end,
  },

  -- Blade Template Support
  {
    "jwalton512/vim-blade",
    ft = "blade",
  },

  -- Code Completion for Laravel
  {
    "noahfrederick/vim-laravel",
    dependencies = {
      "tpope/vim-dispatch",
      "tpope/vim-projectionist",
    },
  },

  -- Additional LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              stubs = {
                "bcmath",
                "bz2",
                "Core",
                "curl",
                "date",
                "dom",
                "fileinfo",
                "filter",
                "gd",
                "gettext",
                "hash",
                "iconv",
                "imap",
                "intl",
                "json",
                "libxml",
                "mbstring",
                "mysqli",
                "openssl",
                "pcre",
                "pdo",
                "pdo_mysql",
                "phar",
                "posix",
                "readline",
                "session",
                "standard",
                "tokenizer",
                "xml",
                "zip",
                "laravel",
              },
            },
          },
        },
      },
    },
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "xdebug/xdebug",
    },
  },
}
