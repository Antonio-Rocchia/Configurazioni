return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  opts = {
    -- see :h nvim-treesitter-modules
    highlight = { enable = true },
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
    auto_install = true,
    textobjects = {
      move = {
        enable = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_next_end = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]p"] = "@parameter.outer" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[p"] = "@parameter.outer" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[P"] = "@parameter.outer" },
      },
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["ip"] = { query = "@parameter.inner", desc = "Select inside the function parameter" },
          ["ap"] = { query = "@parameter.outer", desc = "Select around the function parameter" },
          ["af"] = { query = "@function.outer", desc = "Select around the function region" },
          ["if"] = { query = "@function.inner", desc = "Select inside the function region" },
          ["ac"] = { query = "@class.outer", desc = "Select around the class region" },
          ["ic"] = { query = "@class.inner", desc = "Select inside the class region" },
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
