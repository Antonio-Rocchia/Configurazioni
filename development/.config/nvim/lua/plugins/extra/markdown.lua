return {
  "iamcco/markdown-preview.nvim",
  dependencies = {
    "iamcco/mathjax-support-for-mkdp",
  },
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    -- vim.cmd([[
    --   function OpenMarkdownPreview (url)
    --     execute "silent ! chromium --new-window --app=" . a:url
    --   endfunction
    -- ]])
    -- vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
  end,
}
