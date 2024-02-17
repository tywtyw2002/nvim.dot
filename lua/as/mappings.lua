local map_wrapper = require("as.utils.core").map

local M = {}

local function termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local local_mappings = function()
    -- Don't copy the replaced text after pasting in visual mode
    map_wrapper("v", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

    -- don't yank text on cut ( x )
    map_wrapper({ "n", "v" }, "x", '""x')

    -- don't yank text on cut ( c )
    map_wrapper({ "n", "v" }, "c", '""c')

    -- don't yank text on delete ( dd )
    map_wrapper({ "n", "v" }, "d", '""d')

    map_wrapper("n", "<localleader>p", '""p')
    map_wrapper("n", "<localleader>P", '""P')

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    map_wrapper({ "n", "x", "o" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    map_wrapper({ "n", "x", "o" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
    map_wrapper("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
    map_wrapper("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

    -- Toggle top/center/bottom
    map_wrapper(
        "n",
        "zz",
        [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']],
        { expr = true }
    )

    -- use ESC to turn off search highlighting
    map_wrapper("n", "<Esc>", ":noh <CR>")

    -- Map Q to replay q register
    map_wrapper("n", "Q", "@q")

    -- center cursor when moving (goto_definition)

    -- yank from current cursor to end of line
    map_wrapper("n", "Y", "yg$")

    -- navigation within insert mode
    map_wrapper("i", "<C-h>", "<Left>")
    map_wrapper("i", "<C-e>", "<End>")
    map_wrapper("i", "<C-l>", "<Right>")
    map_wrapper("i", "<C-k>", "<Up>")
    map_wrapper("i", "<C-j>", "<Down>")
    map_wrapper("i", "<C-a>", "<C-o>^")

    -- cmd mode nav
    --map_wrapper("c", "<C-a>", "<Home>")
    --map_wrapper("c", "<C-e>", "<End>")
    vim.cmd([[cmap <C-a> <Home>]])
    vim.cmd([[cmap <C-e> <End>]])
    --map_wrapper("c", "<C-j>", [[wildmenumode() ? "\<Tab>" : "\<c-j>"]], {expr = true})
    --map_wrapper("c", "<C-k>", [[wildmenumode() ? "\<S-Tab>" : "\<c-k>"]], {expr = true})
    vim.cmd([[cmap <expr> <C-j> wildmenumode() ? "\<Tab>" : "\<c-j>"]])
    vim.cmd([[cmap <expr> <C-k> wildmenumode() ? "\<S-Tab>" : "\<c-k>"]])
    vim.cmd([[cmap <expr> <C-h> wildmenumode() ? "\<Up>" : "\<c-h>"]])
    vim.cmd([[cmap <expr> <C-l> wildmenumode() ? "\<Down>\<Tab>" : "\<c-l>"]])

    -- copy whole file content
    --map_wrapper("n", "<C-a>", ":%y+ <CR>")

    -- copy selected text (visual mode) or curent line (normal)
    map_wrapper("v", "<C-c>", '"+y')
    map_wrapper("n", "<C-c>", '"+yy') -- copy curent line in normal mode

    -- toggle relative numbers
    --map("n", maps.misc.relative_line_number_toggle, ":set rnu! <CR>")

    -- Evaluates whether there is a fold on the current line if so unfold it else return a normal space
    map_wrapper("", "<space><space>", [[@=(foldlevel('.')?'za':"\<Space>")<CR>]])

    -- toggle paste mode
    --map_wrapper("n", ";i", ":set paste! <CR>")

    -- Plugin search cmd lines
    --map_wrapper('c', [[<C-R>]], '<Plug>(TelescopeFuzzyCommandSearch)', {noremap = true})
    vim.cmd([[cmap <C-\> <Plug>(TelescopeFuzzyCommandSearch)]])
end

local neovide_mappings = function()
    if not vim.g.neovide then
        return
    end

    vim.g.neovide_input_use_logo = true

    map_wrapper("n", "<D-s>", ":w <CR>")
    map_wrapper("v", "<D-c>", '"+y')
    map_wrapper("i", "<D-v>", '<c-o>"+p')
    vim.cmd([[cmap <D-v> <C-r>*]])
    map_wrapper({ "n", "i" }, "<D-/>", "<cmd>lua require('Comment.api').toggle_current_linewise() <CR>")
end

M.do_misc_mapping = function()
    local_mappings()
    neovide_mappings()
end

M.general_mappings = {
    ["<leader>X"] = {
        "<Cmd>lua require('as.utils.core').close_buffer() <CR>",
        "Close Buffer ",
    },
    ["<C-s>"] = { "<cmd> w <CR>", "Save File ﬚" },
    ["<leader>nb"] = { "<cmd>enew <CR>", "New Buffer 烙" },
    ["<leader>nt"] = { "<cmd>tabnew <CR>", "New Tab 烙" },
    ["<leader>nu"] = { "<cmd>set nu! <CR>", "Toggle Line Number " },
    ["<leader>ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
    ["<Esc><Esc>"] = {
        termcodes("<C-\\><C-N>"),
        "Escape Terminal Mode ",
        mode = "t",
        noremap = false,
    },
}

-- Plugins
M.bufferline = {
    ["<leader><tab>"] = { "<Cmd>BufferLineCycleNext<CR>", "Bufferline: Next" },
    ["<S-tab>"] = { "<Cmd>BufferLineCyclePrev<CR>", "Bufferline: Previous" },
    ["<leader>ns"] = { "<Cmd>BufferLinePick<CR>", "Bufferline: Pick Buffer" },
    ["<leader>nx"] = { "<Cmd>BufferLinePickClose<CR>", "Bufferline: Delete Buffer" },
    --["gD"] = {"<Cmd>BufferLinePickClose<CR>", "bufferline: delete buffer"},
    --["gb"] = {"<Cmd>BufferLinePick<CR>", "bufferline: pick buffer"},
    --["[b"] = {"<Cmd>BufferLineMoveNext<CR>", "bufferline: move next"},
    --["]b"] = {"<Cmd>BufferLineMovePrev<CR>", "bufferline: move prev"},
    --["<leader>1"] = {"<Cmd>BufferLineGoToBuffer 1<CR>", "which_key_ignore"},
}

M.comment = {
    ["<leader>/"] = {
        "<cmd>lua require('Comment.api').toggle_current_linewise() <CR>",
        "Comment: 蘒  Toggle",
    },
    ["<Leader>/"] = {
        "<ESC><cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>",
        "Comment: 蘒  Toggle",
        mode = "v",
        noremap = false,
    },
}

M.copilot = {
    ["<leader>co"] = {
        "<cmd>Copilot! attach <CR>",
        "Copilot: Attach  ",
    },
    ["<leader>cD"] = {
        "<cmd>Copilot detach <CR>",
        "Copilot: Detach  ",
    },
}

M.dashboard = {
    ["<leader>bm"] = { "<Cmd>DashboardJumpMarks <CR>", "Dashboard: Bookmark" },
    ["<leader>fn"] = { "<Cmd>DashboardNewFile <CR>", "Dashboard: New File" },
    ["<leader>db"] = { "<Cmd>Dashboard <CR>", "Dashboard: Open" },
    ["<leader>dl"] = { "<Cmd>SessionLoad <CR>", "Dashboard: Load Session" },
    ["<leader>ds"] = { "<Cmd>SessionSave <CR>", "Dashboard: Save Session" },
}

M.lsp = {
    ["gD"] = {
        "<cmd>lua vim.lsp.buf.declaration()<CR>",
        "LSP: Go Declaration",
    },
    ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "LSP: Go Definition" },
    ["gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "LSP: Go Reference" },
    ["gi"] = {
        "<cmd>lua vim.lsp.buf.implementation()<CR>",
        "LSP: Go Implementation",
    },
    ["gI"] = {
        "<cmd>lua vim.lsp.buf.incoming_calls()<CR>",
        "LSP: Go Incoming Calls",
    },
    ["gk"] = {
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        "LSP: Signature Help",
    },
    ["ge"] = {
        "<cmd>lua vim.diagnostic.open_float()<CR>",
        "LSP: Show Diagnostics",
    },
    ["[d"] = {
        "<cmd>lua vim.diagnostic.goto_prev()<CR>",
        "LSP: Previous Diagnostic",
    },
    ["]d"] = {
        "<cmd>lua vim.diagnostic.goto_next()<CR>",
        "LSP: Next Diagnostic",
    },
    ["<leader>q"] = {
        "<cmd>lua vim.diagnostic.setloclist()<CR>",
        "LSP: Set Local List",
    },
    ["<leader>wa"] = {
        "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
        "LSP: Add Workspace Folder",
    },
    ["<leader>wr"] = {
        "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
        "LSP: Remove Workspace Folder",
    },
    ["<leader>wl"] = {
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        "LSP: List Workspace Folder",
    },
    ["<leader>D"] = {
        "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        "LSP: Show Type Definition",
    },
    ["<leader>ra"] = { "<cmd>lua require'as.features.renamer'.open() <CR>", "LSP: Rename" },
    ["<leader>ca"] = {
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        "LSP: Code Action",
    },
    -- x map
    ["<Leader>ca"] = {
        "<esc><cmd>lua vim.lsp.buf.range_code_action()<CR>",
        "LSP: Code Action",
        mode = "x",
        noremap = false,
    },
    ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "LSP: Hover" },
    ["<leader>fm"] = {
        "<cmd>lua vim.lsp.buf.format { async = true }<CR>",
        "LSP: Format Buffer",
    },
}

M.nvimtree = {
    ["<leader><C-n>"] = { "<cmd>NvimTreeToggle <CR>", "NvimTree: Toggle " },
    ["<leader>e"] = { "<cmd>NvimTreeFocus <CR>", "NvimTree: Focus " },
}

M.nvterm = {
    ["<A-i>"] = {
        "<cmd>lua require('nvterm.terminal').toggle('float') <CR>",
        "Toggle Floating Term ",
        mode = "t",
        noremap = false,
    },
    ["<A-h>"] = {
        "<cmd>lua require('nvterm.terminal').toggle('horizontal') <CR>",
        "Toggle Horizontal Term ",
        mode = "t",
        noremap = false,
    },
    ["<A-v>"] = {
        "<cmd>lua require('nvterm.terminal').toggle('vertical') <CR>",
        "Toggle Vertical Term ",
        mode = "t",
        noremap = false,
    },
    ["<a-i>"] = {
        "<cmd>lua require('nvterm.terminal').toggle('float') <CR>",
        "Toggle Floating Term ",
    },
    ["<a-h>"] = {
        "<cmd>lua require('nvterm.terminal').toggle('horizontal') <CR>",
        "Toggle Horizontal Term ",
    },
    ["<a-v>"] = {
        "<cmd>lua require('nvterm.terminal').toggle('vertical') <CR>",
        "Toggle Vertical Term ",
    },
    ["<leader>nh"] = {
        "<cmd>lua require('nvterm.terminal').new('horizontal') <CR>",
        "New Horizontal Term ",
    },
    ["<leader>nv"] = {
        "<cmd>lua require('nvterm.terminal').new('vertical') <CR>",
        "New Vertical Term ",
    },
}

M.telescope = {
    ["<leader>fb"] = {
        "<cmd>lua require('telescope.builtin').buffers() <CR>",
        "Telescope: Find Buffer",
    },
    ["<leader>ff"] = {
        "<cmd>lua require('telescope.builtin').find_files() <CR>",
        "Telescope: Find File",
    },
    ["<leader>fa"] = {
        "<cmd>lua require('telescope.builtin').find_files({follow=true, no_ignore=true, hidden=true}) <CR>",
        "Telescope: Find All Files",
    },
    ["<leader>fg"] = { "<cmd>lua require('telescope.builtin').git_files() <CR>", "Telescope: Git Files" },
    ["<leader>fh"] = { "<cmd>lua require('telescope').extensions.frecency.frecency() <CR>", "Telescope: Frecency" },
    ["<leader>fr"] = { "<cmd>lua require('telescope.builtin').resume() <CR>", "Telescope: Resume" },
    ["<leader>f?"] = { "<cmd>lua require('telescope.builtin').help_tags() <CR>", "Telescope: Help Tags" },
    ["<leader>fw"] = { "<cmd>lua require('telescope.builtin').live_grep() <CR>", "Telescope: Grep" },
    ["<leader>fs"] = { "<cmd>lua require('telescope.builtin').treesitter() <CR>", "Telescope: Treesitter" },
    ["<leader>fk"] = { "<cmd>lua require('telescope.builtin').keymaps() <CR>", "Telescope: Keymaps" },
    ["<leader>fo"] = {
        "<cmd>lua require('telescope.builtin').oldfiles() <CR>",
        "Telescope: Old Files",
    },
    ["<leader>gc"] = {
        "<cmd>lua require('telescope.builtin').git_commits() <CR>",
        "Telescope: Git Commit",
    },
    ["<leader>gs"] = {
        "<cmd>lua require('telescope.builtin').git_status() <CR>",
        "Telescope: Git Status",
    },
    ["<leader>gb"] = {
        "<cmd>lua require('telescope.builtin').git_branches() <CR>",
        "Telescope: Git Status",
    },
    ["<leader>fz"] = {
        "<cmd>lua require('telescope.builtin').commands() <CR>",
        "Telescope: Commands",
    },
    ["<leader>ft"] = {
        name = "Telescope: +tmux",
        s = {
            function()
                require("telescope").extensions.tmux.sessions({})
            end,
            "sessions",
        },
        w = {
            function()
                require("telescope").extensions.tmux.windows({
                    entry_format = "#S: #T",
                })
            end,
            "windows",
        },
    },
}

M.undotree = {
    ["<leader>u"] = { "<cmd>UndotreeToggle<CR>", "Undotree: Toggle" },
}

M.trailspace = {
    [";fs"] = { "<cmd>lua MiniTrailspace.trim() <CR>", "Remove Trailing Space." },
}

M.trouble = {
    ["<leader>ld"] = { "<cmd>TroubleToggle <CR>", "Trouble: Toggle" },
    ["<leader>lx"] = { "<cmd>TroubleToggle <CR>", "Trouble: Toggle document_diagnostics" },
    ["<leader>lw"] = {
        "<cmd>TroubleToggle workspace_diagnostics <CR>",
        "Trouble: Workspace Toggle",
    },
    ["<leader>lq"] = {
        "<cmd>TroubleToggle quickfix <CR>",
        "Trouble: Quickfix Toggle",
    },
    ["gR"] = {
        "<cmd>TroubleToggle lsp_references <CR>",
        "Trouble: Lsp References",
    },
    --["[e"] = {
    --    "<cmd>lua require('trouble').previous({skip_groups = true, jump = true}) <CR>",
    --    "Trouble: Previous",
    --},
    --["]e"] = {
    --    "<cmd>lua require('trouble').next({skip_groups = true, jump = true}) <CR>",
    --    "Trouble: Next",
    --},
}

return M
