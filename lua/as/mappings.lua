local M = {}

-- Plugins
M.bufferline = {
    ["<leader><tab>"] = { "<Cmd>BufferLineCycleNext<CR>", "bufferline: next" },
    ["<S-tab>"] = { "<Cmd>BufferLineCyclePrev<CR>", "bufferline: prev" },
    --["gD"] = {"<Cmd>BufferLinePickClose<CR>", "bufferline: delete buffer"},
    --["gb"] = {"<Cmd>BufferLinePick<CR>", "bufferline: pick buffer"},
    --["[b"] = {"<Cmd>BufferLineMoveNext<CR>", "bufferline: move next"},
    --["]b"] = {"<Cmd>BufferLineMovePrev<CR>", "bufferline: move prev"},
    --["<leader>1"] = {"<Cmd>BufferLineGoToBuffer 1<CR>", "which_key_ignore"},
}

M.comment = {
    ["<leader>/"] = {
        "<cmd>lua require('Comment.api').toggle_current_linewise() <CR>",
        "Comment: Toggle",
    },
    ["<Leader>/"] = {
        "<cmd>lua require('Comment.api').toggle_current_linewise() <CR>",
        "Comment: Toggle",
        mode = "v",
        noremap = false,
    },

    --map("v", m, ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")
}

--M.comment_v = {
--    ["<leader>/"] = {
--        function() require('Comment.api').toggle_linewise_op(vim.fn.visualmode()) end,
--        "Comment: Toggle"
--    }
--}

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
    ["<leader>ra"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "LSP: Rename" },
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
        "<cmd>lua vim.lsp.buf.formatting()<CR>",
        "LSP: Format Buffer",
    },
}

M.nvimtree = {
    ["<C-n>"] = { "<cmd>NvimTreeToggle <CR>", "Nvim-Tree: Toggle" },
    ["<leader>e"] = { "<cmd>NvimTreeFocus <CR>", "vim-Tree: Focus" },
}

M.telescope = {
    ["<leader>fb"] = {
        "<cmd>Telescope buffers <CR>",
        "Telescope: Find Buffer",
    },
    ["<leader>ff"] = {
        "<cmd>Telescope find_files <CR>",
        "Telescope: Find File",
    },
    ["<leader>fa"] = {
        "<cmd>Telescope find_files follow=true no_ignore=true hidden=true <CR>",
        "Telescope: Find File(All)",
    },
    ["<leader>fh"] = { "<cmd>Telescope frecency <CR>", "Telescope: History" },
    --["<leader>fh"] = {"<cmd>Telescope help_tags <CR>", "Telescope: Help"},
    ["<leader>fw"] = { "<cmd>Telescope live_grep <CR>", "Telescope: Grep" },
    ["<leader>fo"] = {
        "<cmd>Telescope oldfiles <CR>",
        "Telescope: Old Files",
    },
    ["<leader>cm"] = {
        "<cmd>Telescope git_commits <CR>",
        "Telescope: Git Commit",
    },
    ["<leader>gt"] = {
        "<cmd>Telescope git_status <CR>",
        "Telescope: Git Status",
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
    [";fs"] = { "<cmd>FixWhitespace<CR>", "Remove Trailing Space." },
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
