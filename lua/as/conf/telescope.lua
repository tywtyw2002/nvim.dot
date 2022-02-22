local M = {}

M.requires = {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        after = "telescope.nvim",
        config = function()
            require("telescope").load_extension("fzf")
        end,
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        after = "telescope.nvim",
        requires = "tami5/sqlite.lua",
    },
    {
        "camgraff/telescope-tmux.nvim",
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
    local default = {
        defaults = {
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
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8,
                },
                vertical = {
                    mirror = false,
                },
                width = 0.87,
                height = 0.80,
                preview_cutoff = 120,
            },
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            file_ignore_patterns = { "node_modules" },
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            path_display = { "truncate" },
            winblend = 0,
            border = {},
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            use_less = true,
            set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            -- Developer configurations: Not meant for general override
            buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        },
    }

    local telescope = require("telescope")
    telescope.setup(default)

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
