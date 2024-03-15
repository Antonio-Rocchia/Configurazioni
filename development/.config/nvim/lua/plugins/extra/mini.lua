return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.comment").setup()
    require("mini.pairs").setup({
      mappings = {
        ["'"] = false,
        ['"'] = false,
        ["`"] = false,
        ["("] = { neigh_pattern = "[^\\]%W" },
        ["["] = { neigh_pattern = "[^\\]%W" },
        ["{"] = { neigh_pattern = "[^\\]%W" },
      },
    })
    require("mini.bufremove").setup()
    require("mini.surround").setup({
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    })
    require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
  end,
}
