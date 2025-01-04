local M = {}

local default = {
    ensure_installed = {
        "lua",
        "python",
        "vim",
        "rust",
        "nix",
        "bash",
        "go",
        "gomod",
        "gosum",
        "toml",
        "yaml",
        "json",
        "c",
        "html",
        "css",
        "javascript",
        -- "typescript",
        -- "tsx"
    },
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
                ["af"] = {
                    query = "@function.outer",
                    desc = "TS [S] Function Outer",
                },
                ["if"] = {
                    query = "@function.inner",
                    desc = "TS [S] Function Inner",
                },
                ["ac"] = { query = "@class.outer", desc = "TS [S] Class Outer" },
                ["ic"] = { query = "@class.inner", desc = "TS [S] Class Inner" },
                ["ad"] = {
                    query = "@conditional.outer",
                    desc = "TS [S] Cond Outer",
                },
                ["id"] = {
                    query = "@conditional.inner",
                    desc = "TS [S] Cond Inner",
                },
                ["ak"] = { query = "@call.outer", desc = " TS [S] Call Outer" },
                ["ik"] = { query = "@call.inner", desc = "TS [S] Call Inner" },
                ["as"] = {
                    query = "@statement.outer",
                    desc = "TS [S] Statement Outer",
                },
                ["is"] = {
                    query = "@statement.inner",
                    desc = "TS [S] Statement Inner",
                },
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
    autopairs = { enable = true },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
    },
}

M.options = function()
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")

    return default
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

M.keybinds = function()
    local map = vim.keymap.set
end

return M
