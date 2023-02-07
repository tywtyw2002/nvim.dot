return function()
    dofile(vim.g.base46_cache .. "whichkey")
    local wk = require("which-key")
    wk.setup({
        plugins = {
            spelling = {
                enabled = true,
            },
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "  ", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
        },

        popup_mappings = {
            scroll_down = "<c-d>", -- binding to scroll down inside the popup
            scroll_up = "<c-u>", -- binding to scroll up inside the popup
        },

        window = {
            border = "none", -- none/single/double/shadow
        },
        layout = {
            spacing = 6, -- spacing between columns
        },
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
        triggers_blacklist = {
            n = { " " },
            i = { "j", "k" },
            v = { "j", "k" },
        },
    })
    -- Register general Mappings
    wk.register(require("as.mappings").general_mappings)
    -- Which-key
    wk.register({
        ["<leader>wK"] = {
            "<cmd> WhichKey <CR>",
            "Which-key: All Keymaps ",
        },
        ["<leader>wk"] = {
            function()
                local input = vim.fn.input("WhichKey: ")
                vim.cmd("WhichKey " .. input)
            end,
            "Which-key: Query ",
        },
    })
end
