return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { },
  opts = {
    -- see :h nvim-treesitter-modules
    highlight = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-Space>",
        node_incremental = "<C-Space>",
        node_decremental = "<bs>",
        scope_incremental = false,
      },
    },
    indent = { enable = true },
    -- Parser settings
    ensure_installed = {
      "lua",
      "html",
      "css",
      "javascript",
      "python",
      "bash",
    },
    auto_install = false,
    autotag = {
      enable = true,
    }
  },

  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
