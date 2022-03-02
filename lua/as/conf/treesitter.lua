return function()
    --local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
    --parser_configs.norg_meta = {
    --    install_info = {
    --        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    --        files = { "src/parser.c" },
    --        branch = "main",
    --    },
    --}

    require("nvim-treesitter.configs").setup({
        ensure_installed = "maintained",
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
                node_decremental = "<leader>V", -- decrement to the previous node
                scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
            },
        },
        indent = {
            enable = true,
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
                    ["[w"] = "@parameter.inner",
                },
                swap_previous = {
                    ["]w"] = "@parameter.inner",
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
                    ["<localleader>KP"] = "@parameter.inner",
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
                }
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
        }
    })
end
