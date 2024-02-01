return {
  'echasnovski/mini.nvim',
  version = false,
  event = { "BufReadPost", "BufNewFile" },
  config = function ()
    require("mini.pairs").setup()
    require("mini.comment").setup()
  end
}
