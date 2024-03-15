local tonino_group = vim.api.nvim_create_augroup("tonino", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = tonino_group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Reset cursor before quitting
vim.api.nvim_create_autocmd("VimLeave", {
  group = tonino_group,
  command = "set guicursor=a:ver25",
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- The most used functions are:
    -- - |vim.lsp.buf.hover()|
    -- - |vim.lsp.buf.format()|
    -- - |vim.lsp.buf.references()|
    -- - |vim.lsp.buf.implementation()|
    -- - |vim.lsp.buf.code_action()|
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Code: Hover documentation", buffer = ev.buf })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Code: Signature documentation", buffer = ev.buf })
    -- Formatting is handled with conform.nvim
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { desc = "Code: run code action", buffer = ev.buf })
    vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { desc = "Code: rename symbol", buffer = ev.buf })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Code: references to symbol under cursor in quickfix", buffer = ev.buf })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Code: implementation for symbol under cursor in quickfix", buffer = ev.buf })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Code: go to definition", buffer = ev.buf })
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Code: go to type definition", buffer = ev.buf })
  end,
})
