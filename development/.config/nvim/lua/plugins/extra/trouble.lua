return {
  "folke/trouble.nvim",
  keys = {
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Trouble: workspace diagnostic" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Trouble: buffer diagnostic" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Trouble: loclist" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Trouble: quickfix" },
  },
  opts = {
    use_diagnostic_signs = true,
  },
}
