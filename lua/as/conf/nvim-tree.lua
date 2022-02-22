local M = {}

M.config = function()
    --local action = require('nvim-tree.config').nvim_tree_callback

    vim.g.nvim_tree_icons = {
        default = "",
        symlink = "",
        git = {
            unstaged = "",
            staged = "",
            unmerged = "",
            renamed = "",
            untracked = "",
            deleted = "",
            ignored = "◌",
        },
        folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = "",
            symlink = "",
            symlink_open = "",
        },
    }

    vim.g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
    vim.g.nvim_tree_highlight_opened_files = 1
    --vim.g.nvim_tree_special_files = {}
    vim.g.nvim_tree_indent_markers = 1
    vim.g.nvim_tree_group_empty = 1
    vim.g.nvim_tree_git_hl = 0
    vim.g.nvim_tree_width_allow_resize = 1
    --vim.g.nvim_tree_root_folder_modifier = ':t'
    vim.g.nvim_tree_root_folder_modifier = table.concat({ ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" })
    vim.g.nvim_tree_highlight_opened_files = 1

    vim.g.nvim_tree_window_picker_exclude = {
        filetype = { "notify", "packer", "qf" },
        buftype = { "terminal" },
    }

    vim.g.nvim_tree_show_icons = {
        folders = 1,
        files = 1,
        git = 1,
    }

    require("nvim-tree").setup({
        view = {
            allow_resize = true,
            side = "left",
            width = 25,
            hide_root_folder = true,
        },
        git = {
            enable = true,
            ignore = false,
        },
        diagnostics = {
            enable = true,
        },
        disable_netrw = false,
        hijack_netrw = true,
        open_on_setup = false,
        hijack_cursor = true,
        update_cwd = true,
        update_focused_file = {
            enable = true,
            update_cwd = true,
        },
        filters = {
            custom = { ".DS_Store", "fugitive:", ".git", "node_modules" },
            dotfiles = false,
        },
    })
end

M.setup = function()
    --as.nnoremap('<c-n>', [[<cmd>NvimTreeToggle<CR>]])
    require("which-key").register(require("as.mappings").nvimtree)
end

return M
