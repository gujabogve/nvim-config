-- return {
--   {
--     "maxmx03/fluoromachine.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       local fm = require("fluoromachine")
--
--       fm.setup({
--         glow = false,
--         theme = "fluoromachine",
--         transparent = true,
--       })
--
--       vim.cmd.colorscheme("fluoromachine")
--     end,
--   },
-- }
--
-- return {
--   -- add gruvbox
--   { "samharju/synthweave.nvim" },
--
--   -- Configure LazyVim to load gruvbox
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "synthweave-transparent",
--     },
--   },
-- }
return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
