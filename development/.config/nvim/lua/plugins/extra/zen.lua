return {
  "folke/zen-mode.nvim",
  -- stylua: ignore
  keys = {
      { "<leader>uz", function() require("zen-mode").toggle() end, desc = "Utility: Zen mode", },
  },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
