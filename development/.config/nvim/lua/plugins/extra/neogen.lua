return {
  "danymat/neogen",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "L3MON4D3/LuaSnip",
  },
  opts = {
    snippet_engine = "luasnip",
  },
  config = function(_, opts)
    local neogen = require("neogen")

    neogen.setup(opts)

    vim.keymap.set("n", "<leader>cnm", function()
      neogen.generate({ type = "func" })
    end, { desc = "Code: generate func annotation" })

    vim.keymap.set("n", "<leader>cnc", function()
      neogen.generate({ type = "class" })
    end, { desc = "Code: generate func annotation" })

    vim.keymap.set("n", "<leader>cnf", function()
      neogen.generate({ type = "file" })
    end, { desc = "Code: generate func annotation" })

    vim.keymap.set("n", "<leader>cnt", function()
      neogen.generate({ type = "type" })
    end, { desc = "Code: generate type annotation" })
  end,
}
