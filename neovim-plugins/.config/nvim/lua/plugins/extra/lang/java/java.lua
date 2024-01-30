return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "java" })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "folke/which-key.nvim",
      "mfussenegger/nvim-jdtls",
      { "hrsh7th/cmp-nvim-lsp", dependencies = { { "hrsh7th/nvim-cmp" } } },
    },
    opts = {
      servers = {
        jdtls = {}
      },
      setup = {
        jdtls = function(set_default_map_on_attach)
          -- Attach jdtls for the proper filetypes (i.e. java).
          -- Existing server will be reused if the root_dir matches.
          vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("MyJdtls", { clear = true }),
            pattern = { "java" },
            callback = function()
              local jdtls_path = require("mason-registry").get_package("jdtls"):get_install_path()
              local launcher_filename_pattern = "org%.eclipse%.equinox%.launcher_(.-)%.jar"
              local jdtls_launcher_path = ""

              local jdtls_plugin_path = jdtls_path .. "/plugins/"
              for _, file in ipairs(vim.fn.readdir(jdtls_plugin_path)) do
                if file:match(launcher_filename_pattern) then
                  jdtls_launcher_path = jdtls_plugin_path .. file
                end
              end

              local root_dir = require("jdtls.setup").find_root({ '.git', 'gradlew', })
              local project_name = root_dir and vim.fs.basename(root_dir)

              local capabilities = vim.lsp.protocol.make_client_capabilities()
              capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

              local config = {
                cmd = {
                  -- '/usr/lib/jvm/java-17-openjdk/bin/java',
                  'java',
                  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                  '-Dosgi.bundles.defaultStartLevel=4',
                  '-Declipse.product=org.eclipse.jdt.ls.core.product',
                  '-Dlog.protocol=true',
                  '-Dlog.level=ALL',
                  '-Xmx1g',
                  '--add-modules=ALL-SYSTEM',
                  '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                  '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                  '-jar', jdtls_launcher_path,
                  '-configuration', jdtls_path .. "/config_linux",
                  '-data',
                  vim.fn.expand('~/.cache/jdtsl-workspace/') .. (project_name or vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'))
                },
                root_dir = root_dir,
                capabilities = capabilities,
                settings = {
                  java = {
                    project = {
                      referencedLibraries = {
                        root_dir .. "/lib/jsp-api.jar",
                        root_dir .. "/lib/junit4_4.3.1.jar",
                        root_dir .. "/lib/servlet-api.jar",
                        root_dir .. "/lib/soap.jar",
                      }
                    },
                    configuration = {
                      runtimes = {
                        {
                          name = "JavaSE-11",
                          path = "/usr/lib/jvm/java-11-openjdk/"
                        },
                        {
                          name = "JavaSE-17",
                          path = "/usr/lib/jvm/java-17-openjdk/"
                        }
                      },
                    }
                  }
                }
              }
              require('jdtls').start_or_attach(config)

              set_default_map_on_attach(vim.api.nvim_get_current_buf())

              vim.keymap.set("n", "<leader>co", function() require("jdtls").organize_imports() end, { desc = "Organize Imports", })
              vim.keymap.set("n", "<leader>cR", function() require("jdtls").rename_file() end, { desc = "Rename File", })
              vim.keymap.set("n", "<leader>cxv", function() require("jdtls").extract_variable() end, { desc = "Extract Variable", })
              vim.keymap.set("v", "<leader>cxv", function() require("jdtls").extract_variable({ visual = true }) end, { desc = "Extract Variable", })
              vim.keymap.set("n", "<leader>cxc", function() require("jdtls").extract_constant() end, { desc = "Extract Constant", })
              vim.keymap.set("v", "<leader>cxc", function() require("jdtls").extract_constant({ visual = true }) end, { desc = "Extract Constant", })
              vim.keymap.set("n", "<leader>cxm", function() require("jdtls").extract_method({ visual = true }) end, { desc = "Extract Method", })

              require("which-key").register({ c = { x = { name = "Extract" } } }, { prefix = "<leader>" })

              vim.opt_local.makeprg = "ant -buildfile ant/build.xml"
            end
          })
        end
      }
    },
  }
}
