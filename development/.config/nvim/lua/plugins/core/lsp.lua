return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "folke/neodev.nvim", opts = {} },
    { "j-hui/fidget.nvim", opts = {} },
    { "williamboman/mason.nvim", opts = {} },
    { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = false } },
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  opts = {
    servers = {
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          diagnostics = {
            globals = { "vim", "it", "describe", "before_each", "after_each" },
          },
        },
      },
    },
    setup = {
      -- Handlers for specific servers
      -- read :h mason-lspconfig.setup_handlers()
      -- Each entry should be a key value pair "server-name" = function()
      -- The function should be the lsp handler that is passed to mason_lspconfig
      -- this function is typically the documentation for the desired handler
    },
  },
  config = function(_, opts)
    local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())

    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(opts.servers),
    })

    local mason_handlers = {
      function(server_name) -- Default handler
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          settings = opts.servers[server_name],
        })
      end,
    }
    -- Add additional handler for specific languages
    -- read :h mason-lspconfig.setup_handlers
    for server, handler in pairs(opts.setup) do
      mason_handlers[server] = handler()
    end

    mason_lspconfig.setup_handlers(mason_handlers)

    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noselect,preview",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
        }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "nvim_lsp_signature_help" },
      },
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      preselect = "item",
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      preselect = "item",
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
