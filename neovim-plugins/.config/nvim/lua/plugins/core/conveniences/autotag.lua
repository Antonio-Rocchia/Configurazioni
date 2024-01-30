return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    autotag = {
      enable = true,
    },
  },
  config = function (_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end
}
