local M = {}

local default = {
    view = {
        side = "left",
        width = 25,
    },
    git = {
        enable = true,
        ignore = false,
    },
    actions = {
        open_file = {
            resize_window = true,
        },
    },
    diagnostics = {
        enable = true,
    },
    disable_netrw = true,
    hijack_netrw = true,
    --ignore_ft_on_setup = { "alpha" },
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },
    filters = {
        custom = { ".DS_Store", "fugitive:", ".git", "node_modules" },
        dotfiles = false,
    },
    renderer = {
        root_folder_label = false,
        highlight_git = false,
        highlight_opened_files = "none",
        indent_markers = {
            enable = false,
        },
        icons = {
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
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
                    arrow_open = "",
                    arrow_closed = "",
                },
            },
        },
    },
}

M.options = function()
    dofile(vim.g.base46_cache .. "nvimtree")
    return default
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

return M
