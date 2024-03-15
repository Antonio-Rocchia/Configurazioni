return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
  },
  keys = {
    -- Quick access
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope: find files" },
    { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Telescope: find files" },
    { "<leader>fs", "<cmd>Telescope grep_string<cr>", mode = { "n", "v" }, desc = "Telescope: grep word under cursor" },
    { "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Telescope: live grep" },
    { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Telescope: resume" },
    { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Telescope: commands" },
    { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Telescope: man pages" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope: buffers" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Telescope: keymaps" },
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            prompt_position = "bottom",
            mirror = true,
          },
        },
        sorting_strategy = "ascending",
        selection_strategy = "reset",
        scroll_strategy = "limit",
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-?>"] = actions.which_key,
            ["<Esc>"] = actions.close,
            ["<C-q>"] = actions.send_to_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist,
            ["<C-e>"] = actions.send_to_loclist,
            ["<M-e>"] = actions.send_selected_to_loclist,
          },
          n = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist,
            ["<C-e>"] = actions.send_to_loclist,
            ["<M-e>"] = actions.send_selected_to_loclist,
          },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          --"trim", -- Remove indent from the presented line
        },
        set_env = { ["COLORTERM"] = "truecolor" },
        file_ignore_patterns = {
          "lazy%-lock%.json",
        },
      },
      pickers = {
        find_files = {
          follow = true,
        },
      },
    }
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("fzf")
  end,
}
