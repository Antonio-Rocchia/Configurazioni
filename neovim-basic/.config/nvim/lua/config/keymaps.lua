local map = vim.keymap.set

-- keep cursor in the middle while scrolling
-- map({"n"}, "<C-d>", "<C-d>zz", {expr = true, silent = true, desc = "keep cursor in the middle while scrolling"})
-- map({"n"}, "<C-u>", "<C-u>zz", {expr = true, silent = true, desc = "keep cursor in the middle while scrolling"})
-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search highlight with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
