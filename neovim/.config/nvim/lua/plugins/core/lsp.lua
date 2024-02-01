return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "williamboman/mason.nvim", build = ":MasonUpdate", opts = {}, },
    { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = false, }, },
    { "folke/neodev.nvim",    opts = {} },
    { "hrsh7th/cmp-nvim-lsp", dependencies = { { "hrsh7th/nvim-cmp" } } },
    { "j-hui/fidget.nvim", tag = "legacy", event = "LspAttach", opts = {} },
  },
  keys = {
    -- read :h vim.diagnostic
    { "<leader>cd", vim.diagnostic.open_float, desc = "Line diagnostic" },
    { "[d",         vim.diagnostic.goto_prev,  desc = "Previous diagnostic" },
    { "]d",         vim.diagnostic.goto_next,  desc = "Next diagnostic" },
  },
  opts = {
    servers = {
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    },
    setup = {
      -- Handlers for specific servers
    }
  },
  config = function(_, opts)
    -- This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- to check nvim function that support lsp capabilities reaad :h vim.lsp
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action", buffer = bufnr })
      vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "LSP: Format", buffer = bufnr })
      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP: Rename symbol", buffer = bufnr })
      vim.keymap.set("n", "<leader>cI", "<Cmd>LspInfo<CR>", { desc = "LSP: LspInfo", buffer = bufnr })
      vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, { desc = "LSP: Signature documentation (temporary)", buffer = bufnr })
      vim.keymap.set("n", "<leader>cwa", vim.lsp.buf.add_workspace_folder, { desc = "LSP: Add folder to workspace", buffer = bufnr })
      vim.keymap.set("n", "<leader>cwr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP: Remove folder to workspace", buffer = bufnr })
      vim.keymap.set('n', '<leader>cwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = "LSP: List workspace folders", buffer = bufnr })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Goto declaration", buffer = bufnr })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Goto definition", buffer = bufnr })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Goto implementation", buffer = bufnr })
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "LSP: Goto type definition", buffer = bufnr })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover documentation", buffer = bufnr })
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(opts.servers),
    }

    local mason_handlers = {
      function(server_name) -- Default handler
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = opts.servers[server_name],
        }
      end,
    }
    -- Add additional handler for specific languages
    for server, handler in pairs(opts.setup) do
      mason_handlers[server] = handler(on_attach)
    end

    mason_lspconfig.setup_handlers(mason_handlers)
  end
}
