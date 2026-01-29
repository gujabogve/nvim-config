return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- Enable git delta for diff previews
      current_line_blame = true,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          undo = {
            -- Enable delta for undo history
            use_delta = true,
            side_by_side = true,
            layout_strategy = "vertical",
          },
        },
      })
      require("telescope").load_extension("undo")
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("diffview").setup({
        -- Optional configuration
        view = {
          default = {
            layout = "diff2_horizontal",
          },
        },
      })
    end,
  },
}
