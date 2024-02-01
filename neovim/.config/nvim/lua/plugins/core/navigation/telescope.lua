return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false,
  dependencies = {
    -- Make sure to install ripgrep and fd on your system
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  keys = {
    -- Quick access
    { "<leader><space>", "<cmd>Telescope find_files follow=true<cr>",                    desc = "Find files" },
    { "<leader>,",       "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
    { "<leader>:",       "<cmd>Telescope command_history<cr>",               desc = "Command History" },
    { "<leader>/",       "<cmd>Telescope live_grep follow=true<cr>",                     desc = "Grep (root dir)" },
    { "<leader>\\",      "<cmd>Telescope resume<cr>",                        desc = "Resume last telescope" },
    -- find
    { "<leader>ff",      "<cmd>Telescope find_files<cr>",                    desc = "Find files" },
    { "<leader>fb",      "<cmd>Telescope buffers<cr>",                       desc = "Buffers" },
    { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                      desc = "Recent files" },
    -- search
    { "<leader>sb",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",     desc = "Search in buffer" },
    { "<leader>sc",      "<cmd>Telescope command_history<cr>",               desc = "Command History" },
    { "<leader>sg",      "<cmd>Telescope live_grep<cr>",                     desc = "Grep (root dir)" },
  },
  opts = {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      sorting_strategy = "ascending",
      selection_strategy = "reset",
      scroll_strategy = "limit",
      layout_strategy = "horizontal",
      winblend = 0,
      wrap_results = false,
      initial_mode = "insert",
      mappings = {
        i = {
          -- Main key bindings
          ["<C-j>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end,
          ["<C-k>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end,
          ["<C-q>"] = function(...)
            return require("telescope.actions").close(...)
          end,
          ["<C-h>"] = function(...)
            return require("telescope.actions").cycle_history_prev(...)
          end,
          ["<C-l>"] = function(...)
            return require("telescope.actions").cycle_history_next(...)
          end,
          ["<CR>"] = function(...)
            return require("telescope.actions").select_default(...)
          end,
          ["<C-f>"] = function(...)
            return require("telescope.actions").preview_scrolling_down(...)
          end,
          ["<C-b>"] = function(...)
            return require("telescope.actions").preview_scrolling_up(...)
          end,
          ["<C-w>"] = function(...)
            return require("telescope.actions").which_key(...)
          end,
        },
        n = {
          ["q"] = function(...)
            return require("telescope.actions").close(...)
          end,
          ["<C-j>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end,
          ["<C-k>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end,
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case"
      },
      set_env = { ["COLORTERM"] = "truecolor" },
      file_ignore_patterns = {},
    },
  },
  config = function(_, opts)
    require('telescope').setup(opts)
    require('telescope').load_extension('fzf')
  end
}
