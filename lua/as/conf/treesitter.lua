local ts = "<cmd>lua require'nvim-treesitter.textobjects.move'"

local function cmd_go_start(query)
    return ts .. '.goto_previous_start("' .. query .. '")<CR>'
end

local function cmd_go_end(query)
    return ts .. '.goto_next_end("' .. query .. '")<CR><Right>'
end

return function()
    dofile(vim.g.base46_cache .. "syntax")

    require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "vim" },
        highlight = {
            enable = true,
            use_languagetree = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                -- mappings for incremental selection (visual mappings)
                init_selection = "<leader>v", -- maps in normal mode to init the node/scope selection
                node_incremental = "<leader>v", -- increment to the upper named parent
                node_decremental = "<BS>", -- decrement to the previous node
                scope_incremental = "<TAB>", -- increment to the upper scope (as defined in locals.scm)
            },
        },
        indent = {
            enable = true,
            disable = { "python" },
        },
        textobjects = {
            lookahead = true,
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["ad"] = "@conditional.outer",
                    ["id"] = "@conditional.inner",
                    ["ak"] = "@call.outer",
                    ["ik"] = "@call.inner",
                    ["as"] = "@statement.outer",
                    ["is"] = "@statement.inner",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["]w"] = "@parameter.inner",
                },
                swap_previous = {
                    ["[w"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = false, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                    ["]p"] = "@parameter.inner",
                    ["]b"] = "@block.outer",
                    ["]s"] = "@statement.outer",
                    ["<localleader>kf"] = "@function.inner",
                    ["<localleader>kc"] = "@class.inner",
                    ["<localleader>kd"] = "@conditional.inner",
                    ["<localleader>kl"] = "@loop.inner",
                    ["<localleader>kk"] = "@call.inner",
                },
                goto_next_end = {
                    ["<localleader>kF"] = "@function.inner",
                    ["<localleader>kC"] = "@class.inner",
                    ["<localleader>kD"] = "@conditional.inner",
                    ["<localleader>kL"] = "@loop.inner",
                    ["<localleader>kP"] = "@parameter.inner",
                    ["<localleader>kK"] = "@call.inner",
                    ["<localleader>kB"] = "@block.outer",
                    ["<localleader>kS"] = "@statement.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                    ["[p"] = "@parameter.inner",
                    ["[b"] = "@block.outer",
                    ["[s"] = "@statement.outer",
                    ["<localleader>jf"] = "@function.inner",
                    ["<localleader>jc"] = "@class.inner",
                    ["<localleader>jd"] = "@conditional.inner",
                    ["<localleader>jl"] = "@loop.inner",
                    ["<localleader>jk"] = "@call.inner",
                },
                goto_previous_end = {
                    ["<localleader>jF"] = "@function.inner",
                    ["<localleader>jC"] = "@class.inner",
                    ["<localleader>jD"] = "@conditional.inner",
                    ["<localleader>jL"] = "@loop.inner",
                    ["<localleader>jP"] = "@parameter.inner",
                    ["<localleader>jK"] = "@call.inner",
                    ["<localleader>jB"] = "@block.outer",
                    ["<localleader>jS"] = "@statement.outer",
                },
            },
            lsp_interop = {
                enable = true,
                border = "rounded",
                peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                    ["<leader>dF"] = "@class.outer",
                },
            },
        },
        rainbow = {
            enable = true,
            disable = { "json", "html" },
            colors = {
                "royalblue3",
                "darkorange3",
                "seagreen3",
                "firebrick",
                "darkorchid3",
            },
        },
        autopairs = { enable = true },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
        playground = {
            enable = true,
        },
    })

    local ok, w = pcall(require, "which-key")

    if not ok then
        return
    end

    w.register({
        ["]p"] = "[S] Parameter Inner",
        ["]b"] = "[S] Block Outer",
        ["]s"] = "[S] Statement Outer",
        ["]]"] = "[S] Class Outer",
        ["]w"] = "Swap Next Parameter",
        ["[p"] = "[S] Parameter Inner",
        ["[b"] = "[S] Block Outer",
        ["[s"] = "[S] Statement Outer",
        ["[["] = "[S] Class Outer",
        ["[w"] = "Swap Previous Parameter",
        ["<localleader>j"] = {
            name = "Go Previous [I]",
            f = "[S]Function Inner",
            c = "[S]Class Inner",
            d = "[S]Conditional Inner",
            l = "[S]Loop Inner",
            k = "[S]Call Inner",
            F = "[E]Function Inner",
            C = "[E]Class Inner",
            D = "[E]Conditional Inner",
            L = "[E]Loop Inner",
            K = "[E]Call Inner",
            P = "[E] Parameter Inner",
            B = "[E] Block Inner",
            S = "[E] Statement Outer",
        },
        ["<localleader>k"] = {
            name = "Go Next [I]",
            f = "[S]Function Inner",
            c = "[S]Class Inner",
            d = "[S]Conditional Inner",
            l = "[S]Loop Inner",
            k = "[S]Call Inner",
            F = "[E]Function Inner",
            C = "[E]Class Inner",
            D = "[E]Conditional Inner",
            L = "[E]Loop Inner",
            K = "[E]Call Inner",
            P = "[E] Parameter Inner",
            B = "[E] Block Inner",
            S = "[E] Statement Outer",
        },
    })
    w.register({
        ["af"] = "function.outer",
        ["if"] = "function.inner",
        ["ac"] = "class.outer",
        ["ic"] = "class.inner",
        ["ad"] = "conditional.outer",
        ["id"] = "conditional.inner",
        ["ak"] = "call.outer",
        ["ik"] = "call.inner",
        ["as"] = "statement.outer",
        ["is"] = "statement.inner",
    }, {
        mode = "o",
        noremap = false,
    })
    w.register({
        ["sc"] = {
            cmd_go_start("@class.outer"),
            "Start Class",
        },
        ["sC"] = {
            cmd_go_start("@class.inner"),
            "Start Class Inner",
        },
        ["ec"] = {
            cmd_go_end("@class.outer"),
            "End Class",
        },
        ["eC"] = {
            cmd_go_end("@class.inner"),
            "End Class Inner",
        },
        ["sd"] = {
            cmd_go_start("@conditional.outer"),
            "Start Conditional",
        },
        ["sD"] = {
            cmd_go_start("@conditional.inner"),
            "Start Conditional Inner",
        },
        ["ed"] = {
            cmd_go_end("@conditional.outer"),
            "End Conditional",
        },
        ["eD"] = {
            cmd_go_end("@conditional.inner"),
            "End Conditional Inner",
        },
        ["sf"] = {
            cmd_go_start("@function.outer"),
            "Start Function",
        },
        ["sF"] = {
            cmd_go_start("@function.inner"),
            "Start Function Inner",
        },
        ["ef"] = {
            cmd_go_end("@function.outer"),
            "End Function",
        },
        ["eF"] = {
            cmd_go_end("@function.inner"),
            "End Function Inner",
        },
        ["sl"] = {
            cmd_go_start("@loop.outer"),
            "Start Loop",
        },
        ["sL"] = {
            cmd_go_start("@loop.inner"),
            "Start Loop inner",
        },
        ["el"] = {
            cmd_go_end("@loop.outer"),
            "End Loop",
        },
        ["eL"] = {
            cmd_go_end("@loop.inner"),
            "End Loop inner",
        },
        ["ss"] = {
            cmd_go_start("@statement.outer"),
            "Start Statement",
        },
        ["es"] = {
            cmd_go_end("@statement.outer"),
            "End Statement",
        },
        ["sp"] = {
            cmd_go_start("@parameter.outer"),
            "Start Parameter",
        },
        ["ep"] = {
            cmd_go_end("@parameter.outer"),
            "End Parameter",
        },
    }, {
        mode = "i",
        noremap = false,
        prefix = "<C-g>",
    })
end
