-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Better up/down movement" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Better up/down movement" })

-- Clear search highlight with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Mantain visual mode selection after indent" })
vim.keymap.set("v", ">", ">gv", { desc = "Mantain visual mode selection after indent" })

-- Move multiple lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line up/down in visual mode" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up/down in visual mode" })

-- Scroll code and keep cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Keep cursor in the middle while scrolling" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Keep cursor in the middle while scrolling" })

-- In visual mode, after a selection, paste without replacing yanked text with the replaced one
-- vim.keymap.set("x", "<leader>p", [["_dP]])

-- read :h vim.diagnostic
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Code: open diagnostic float" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next: diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev: diagnostic" })

-- Move around the quickfix/location list
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next: quickfix" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Prev: quickfix" })
vim.keymap.set("n", "]e", "<cmd>lnext<CR>zz", { desc = "Next: loclist" })
vim.keymap.set("n", "[e", "<cmd>lprev<CR>zz", { desc = "Prev: loclist" })
