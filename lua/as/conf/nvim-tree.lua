local M = {}

M.config = function()
    dofile(vim.g.base46_cache .. "nvimtree")

    require("nvim-tree").setup({
        view = {
            side = "left",
            width = 25,
            hide_root_folder = true,
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
                }
            }
        },
    })
end

M.setup = function()
    --as.nnoremap('<c-n>', [[<cmd>NvimTreeToggle<CR>]])
    require("which-key").register(require("as.mappings").nvimtree)
end

return M
