local M = {}

M.blankline = function()
    dofile(vim.g.base46_cache .. "blankline")

    local default = {
        indentLine_enabled = 1,
        char = "┊",
        filetype_exclude = {
            "help",
            "terminal",
            "dashboard",
            "lazy",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "nvchad_cheatsheet",
            "mason",
            "alpha",
            "",
        },
        buftype_exclude = { "terminal" },
        show_current_context = true,
        show_current_context_start = true,
        show_first_indent_level = true,
        show_trailing_blankline_indent = true,
    }
    require("indent_blankline").setup(default)
end

M.tmux_navigator = function()
    vim.g.tmux_navigator_no_mappings = 1
    -- Disable tmux navigator when zooming the Vim pane
    vim.g.tmux_navigator_disable_when_zoomed = 1
    vim.g.tmux_navigator_preserve_zoom = 1
    vim.g.tmux_navigator_save_on_switch = 2
    require("which-key").register({
        ["<leader><C-H>"] = { "<cmd>TmuxNavigateLeft<cr>", "Tmux Left" },
        ["<leader><C-J>"] = { "<cmd>TmuxNavigateDown<cr>}", "Tmux Down" },
        ["<leader><C-K>"] = { "<cmd>TmuxNavigateUp<cr>", "Tmux UP" },
        ["<leader><C-L>"] = { "<cmd>TmuxNavigateRight<cr>", "Tmux Right" },
    })
end

M.colorizer = function()
    local default = {
        filetypes = { "*" },
        user_default_options = {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            names = false, -- "Name" codes like Blue
            RRGGBBAA = false, -- #RRGGBBAA hex codes
            rgb_fn = false, -- CSS rgb() and rgba() functions
            hsl_fn = false, -- CSS hsl() and hsla() functions
            css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

            -- Available modes: foreground, background
            mode = "background", -- Set the display mode.
        },
    }
    require("colorizer").setup(default)

    -- execute colorizer as soon as possible
    vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
    end, 0)
end

M.lsp_signature = function()
    local default = {
        bind = true,
        doc_lines = 0,
        floating_window = true,
        fix_pos = true,
        hint_enable = true,
        hint_prefix = " ",
        hint_scheme = "String",
        hi_parameter = "Search",
        max_height = 22,
        max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
        handler_opts = {
            border = "single", -- double, single, shadow, none
        },
        zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
        padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
    }
    require("lsp_signature").setup(default)
end

M.comment = function()
    local default = {}
    require("Comment").setup(default)
end

M.autopairs = function()
    local autopairs = require("nvim-autopairs")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    local default = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
    }

    autopairs.setup(default)

    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.better_escape = function()
    require("better_escape").setup({
        mapping = { "jk" },
        timeout = 300,
    })
end

M.conflict_marker = function()
    -- disable the default highlight group
    vim.g.conflict_marker_highlight_group = 0
    -- Include text after begin and end markers
    vim.g.conflict_marker_begin = "^<<<<<<< .*$"
    vim.g.conflict_marker_end = "^>>>>>>> .*$"

    local set_bg = require("as.utils.core").bg
    set_bg("ConflictMarkerBegin", "#2f7366")
    set_bg("ConflictMarkerOurs", "#2e5049")
    set_bg("ConflictMarkerTheirs", "#344f69")
    set_bg("ConflictMarkerEnd", "#2f628e")
    set_bg("ConflictMarkerCommonAncestorsHunk", "#754a81")
end

M.scrollbar = function()
    require("scrollbar").setup({
        handle = {
            color = require("as.colors").get().one_bg2,
        },
        excluded_filetypes = { "packer" },
    })
end

M.luasnip = function()
    local luasnip = require("luasnip")
    local default = {
        history = true,
        updateevents = "TextChanged,TextChangedI",
    }
    luasnip.config.set_config(default)
    require("luasnip.loaders.from_vscode").lazy_load()
end

M.undotree = function()
    vim.g.undotree_TreeNodeShape = "◉" -- Alternative: '◦'
    vim.g.undotree_SetFocusWhenToggle = 1
end

M.trailspace = function()
    require("mini.trailspace").setup()
end

M.notify = function()
    dofile(vim.g.base46_cache .. "notify")
    local notify = require("notify")

    notify.setup({
        timeout = 3000,
        --max_width = 70
    })

    vim.notify = notify
end

M.nvterm = function()
    local nvterm = require("nvterm")

    local options = {
        terminals = {
            list = {},
            type_opts = {
                float = {
                    relative = "editor",
                    row = 0.3,
                    col = 0.25,
                    width = 0.5,
                    height = 0.4,
                    border = "single",
                },
                horizontal = { location = "rightbelow", split_ratio = 0.3 },
                vertical = { location = "rightbelow", split_ratio = 0.5 },
            },
        },
        behavior = {
            close_on_exit = true,
            auto_insert = true,
        },
        enable_new_mappings = true,
    }

    nvterm.setup(options)
end

M.todo_comments = function()
    local defaults = {}
    require("todo-comments").setup(defaults)
end

M.surround = function()
    local defaults = {
        keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "ms",
            normal_cur = "mss",
            normal_line = "mS",
            normal_cur_line = "mSS",
            visual = "S",
            visual_line = "gS",
            delete = "md",
            change = "mr",
        }
    }
    require("nvim-surround").setup(defaults)
end
return M
