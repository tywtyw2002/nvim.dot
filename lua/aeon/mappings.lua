local map = vim.keymap.set

-- don't yank text on cut ( x )
map({ "n", "v" }, "x", '""x')

-- don't yank text on cut ( c )
map({ "n", "v" }, "c", '""c')

-- don't yank text on delete ( dd )
map({ "n", "v" }, "d", '""d')

-- paste last cut/copied/del text
map("n", "<localleader>p", '""p')
map("n", "<localleader>P", '""P')

-- use ESC to turn off search highlighting
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear Highlights" })

-- Map Q to replay q register
map("n", "Q", "@q", { desc = "replay q register" })

-- yank from current cursor to end of line
map("n", "Y", "yg$", { desc = "yank to end of line" })

map("i", "<C-a>", "<C-o>^")
map("i", "<C-e>", "<End>")
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")

map("n", "<leader>nu", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>nr", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map(
    "n",
    "<leader>ch",
    "<cmd>NvCheatsheet<CR>",
    { desc = "toggle nvcheatsheet" }
)

map("n", ";fm", function()
    require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

map(
    "n",
    ";fs",
    "<cmd>lua MiniTrailspace.trim() <CR>",
    { desc = "General Trim Whitespace" }
)

-- cmd mode nav
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")
vim.cmd([[cmap <expr> <C-j> wildmenumode() ? "\<Tab>" : "\<c-j>"]])
vim.cmd([[cmap <expr> <C-k> wildmenumode() ? "\<S-Tab>" : "\<c-k>"]])
vim.cmd([[cmap <expr> <C-h> wildmenumode() ? "\<Up>" : "\<c-h>"]])
vim.cmd([[cmap <expr> <C-l> wildmenumode() ? "\<Down>\<Tab>" : "\<c-l>"]])

-- neovide
if vim.g.neovide then
    map("n", "<D-s>", ":w <CR>")
    map("v", "<D-c>", '"+y')
    map("i", "<D-v>", '<C-o>"+p')
    map("c", "<D-v>", "<C-r>*")

    map({ "n", "i" }, "<D-/>", function()
        require("Comment.api").toggle_current_linewise()
    end)
end

-- tabufline
map("n", "<leader>nb", "<cmd>enew<CR>", { desc = "buffer new" })
map("n", "<leader>nt", "<cmd>tabnew<CR>", { desc = "buffer new tab" })
map("n", "<leader><tab>", function()
    require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })
map("n", "<S-tab>", function()
    require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })
map("n", "<leader>X", function()
    require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- comment
map("n", "<leader>/", "gcc", { desc = "comment toggle", remap = true })
map("v", "<leader>/", "gc", { desc = "comment toggle", remap = true })

-- nvimtree
map(
    "n",
    "<leader><C-n>",
    "<cmd>NvimTreeToggle<CR>",
    { desc = "nvimtree toggle window" }
)
map(
    "n",
    "<leader>e",
    "<cmd>NvimTreeFocus<CR>",
    { desc = "nvimtree focus window" }
)

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
    vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })
