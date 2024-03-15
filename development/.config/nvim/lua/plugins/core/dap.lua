return {
  {
    "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint", },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Breakpoint Condition", },
      { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end, desc = "Debug: Logpoint", },
      { "<leader>dL", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "), nil, vim.fn.input("Log message: ")) end, desc = "Debug: Logpoint Condition", },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL", },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", { "folke/neodev.nvim", opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    } } },
    keys = {
      {
        "<leader>du",
        function()
          require("dap.ext.vscode").load_launchjs()
          require("dapui").toggle()
        end,
        desc = "Debug: UI",
      },
    },
    opts = {
      mappings = {
        edit = "i",
      },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
  {
    "mfussenegger/nvim-dap-python",
    -- Install debugpy in the project venv
    -- python -m venv debugpy
    -- debugpy/bin/python -m pip install debugpy
    -- stylua: ignore
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/bin/python")
    end,
  },
  {
    "leoluz/nvim-dap-go",
    config = true,
  },
}
