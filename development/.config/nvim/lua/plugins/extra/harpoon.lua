return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    -- Required
    harpoon:setup({})

    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():append()
    end, { desc = "Harpoon: append to list" })
    vim.keymap.set("n", "<leader>hh", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: toggle menu" })
    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon: next buffer" })
    vim.keymap.set("n", "<C-S-N>", function()
      harpoon:list():next()
    end, { desc = "Harpoon: prev buffer" })
    vim.keymap.set("n", "<M-1>", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon: first file" })
    vim.keymap.set("n", "<M-2>", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon: second file" })
    vim.keymap.set("n", "<M-3>", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon: third file" })
    vim.keymap.set("n", "<M-4>", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon: forth file" })
  end,
}
