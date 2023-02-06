local M = {}

M.requires = {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        opt = true,
        run = "make",
        after = "telescope.nvim",
        config = function()
            require("telescope").load_extension("fzf")
        end,
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        opt = true,
        after = "telescope.nvim",
        requires = "tami5/sqlite.lua",
        config = function()
            require("telescope").load_extension("frecency")
        end,
    },
    {
        "camgraff/telescope-tmux.nvim",
        opt = true,
        after = "telescope.nvim",
        config = function()
            require("telescope").load_extension("tmux")
        end,
    },
    --{
    --    "nvim-telescope/telescope-smart-history.nvim",
    --    after = "telescope.nvim",
    --    config = function()
    --        require("telescope").load_extension("smart_history")
    --    end,
    --},
}

M.config = function()
    local actions = require("telescope.actions")
    local layout_actions = require("telescope.actions.layout")
    local themes = require 'telescope.themes'

    local defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        --prompt_prefix = "   ",
        prompt_prefix = "   ",
        --prompt_prefix = "> ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        mappings = {
            i = {
                ["<c-w>"] = actions.send_selected_to_qflist,
                ["<c-c>"] = function()
                    vim.cmd("stopinsert!")
                end,
                ["<esc>"] = actions.close,
                ["<c-s>"] = actions.select_horizontal,
                ["<c-j>"] = actions.cycle_history_next,
                ["<c-k>"] = actions.cycle_history_prev,
                ["<c-e>"] = layout_actions.toggle_preview,
                ["<c-z>"] = layout_actions.cycle_layout_next
            },
            n = {
                ["<c-w>"] = actions.send_selected_to_qflist,
            },
        },
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        --layout_strategy = "horizontal",
        layout_strategy = "flex",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                preview_cutoff = 120,
                --results_width = 0.8,
            },
            vertical = {
                prompt_position = "top",
                mirror = false,
                preview_cutoff = 22,
            },
            flex = {
                flip_columns = 120,
            },
            width = 0.87,
            height = 0.80,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = {
            "─",
            "│",
            "─",
            "│",
            "╭",
            "╮",
            "╯",
            "╰",
        },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    }

    local pickers = {
        builtin = {
            include_extensions = true,
            previewer = false,
        },
        colorscheme = { enable_preview = true },
        current_buffer_fuzzy_find = { skip_empty_lines = true },
        lsp_code_actions = { theme = "cursor" },
        lsp_range_code_actions = { theme = "cursor" },
        spell_suggest = { theme = "cursor" },
        symbols = { sources = { "emoji", "latex" } },
        live_grep = {
            file_ignore_patterns = { ".git/", "node_modules" },
        },
        buffers = {
            sort_mru = true,
            sort_lastused = true,
            show_all_buffers = true,
            ignore_current_buffer = true,
            --theme = 'dropdown',
            previewer = false,
            mappings = {
                i = { ["<c-x>"] = "delete_buffer" },
                n = { ["<c-x>"] = "delete_buffer" },
            },
        },
    }

    local telescope = require("telescope")
    telescope.setup({
        ["defaults"] = defaults,
        ["pickers"] = pickers,
    })

    --local extensions = { "themes", "terms" }
    local extensions = {}

    pcall(function()
        for _, ext in ipairs(extensions) do
            telescope.load_extension(ext)
        end
    end)
end

M.setup = function()
    require("which-key").register(require("as.mappings").telescope)
    --local builtins = require("telescope.builtin")
    --local telescope = require("telescope")

    ----local function project_files(opts)
    ----    if not pcall(builtins.git_files, opts) then
    ----        builtins.find_files(opts)
    ----    end
    ----end

    --local function tmux_sessions()
    --    telescope.
    --end

    --local function tmux_windows()
    --    telescope.extensions.tmux.windows({
    --        entry_format = "#S: #T",
    --    })
    --end

    --require("which-key").register({
    --    ["<c-p>"] = { project_files, "telescope: find files" },
    --    ["<leader>f"] = {
    --        name = "+telescope",
    --        a = { builtins.builtin, "builtins" },
    --        b = { builtins.current_buffer_fuzzy_find, "current buffer fuzzy find" },
    --        --d = { dotfiles, 'dotfiles' },
    --        f = { builtins.find_files, "find files" },
    --        --n = { gh_notifications, 'notifications' },
    --        g = {
    --            name = "+git",
    --            c = { builtins.git_commits, "commits" },
    --            b = { builtins.git_branches, "branches" },
    --        },
    --        m = { builtins.man_pages, "man pages" },
    --        --h = { frecency, 'history' },
    --        o = { builtins.buffers, "buffers" },
    --        --p = { installed_plugins, 'plugins' },
    --        R = { builtins.reloader, "module reloader" },
    --        r = { builtins.resume, "resume last picker" },
    --        s = { builtins.live_grep, "grep string" },
    --        t = {
    --            name = "+tmux",
    --            s = { tmux_sessions, "sessions" },
    --            w = { tmux_windows, "windows" },
    --        },
    --        ["?"] = { builtins.help_tags, "help" },
    --    },
    --    ["<leader>c"] = {
    --        d = { builtins.lsp_workspace_diagnostics, "telescope: workspace diagnostics" },
    --        s = { builtins.lsp_document_symbols, "telescope: document symbols" },
    --        w = { builtins.lsp_dynamic_workspace_symbols, "telescope: workspace symbols" },
    --    },
    --})
end

return M
