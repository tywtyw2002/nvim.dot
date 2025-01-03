local M = {}

local default = {
    defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
        },
    },

    extensions_list = { "themes", "terms" },
    extensions = {},
}

M.options = function()
    dofile(vim.g.base46_cache .. "telescope")
    default.defaults.mappings = {
        n = { ["q"] = require("telescope.actions").close },
    }
    return default
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

M.keybinds = function()
    local builtin = require("telescope.builtin")
    local map = vim.keymap.set

    map("n", "<leader>fb", builtin.buffers, { desc = "Telescope Find Buffer" })
    -- files
    map("n", "<leader>ff", builtin.find_files, { desc = "Telescope Find File" })
    map(
        "n",
        "<leader>fa",
        function() builtin.find_files({ follow = true, no_ignore = true, hidden = true }) end,
        { desc = "Telescope Find All Files" }
    )
    map("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope Old Files" })
    map("n", "<leader>fg", builtin.git_files, { desc = "Telescope Git Files" })
    -- gits
    map(
        "n",
        "<leader>gc",
        builtin.git_commits,
        { desc = "Telescope Git Commits" }
    )
    map(
        "n",
        "<leader>gs",
        builtin.git_status,
        { desc = "Telescope Git Status" }
    )
    map(
        "n",
        "<leader>gb",
        builtin.git_branches,
        { desc = "Telescope Git Branches" }
    )

    -- misc
    map("n", "<leader>fw", builtin.live_grep, { desc = "Telescope Live Grep" })
    map(
        "n",
        "<leader>fz",
        builtin.current_buffer_fuzzy_find,
        { desc = "Telescope Search in Buffer" }
    )
    map("n", "<leader>f?", builtin.help_tags, { desc = "Telescope Help Tags" })
    map("n", "<leader>fc", builtin.commands, { desc = "Telescope Commands" })
    map("n", "<leader>fk", builtin.keymaps, { desc = "Telescope Keymaps" })
    map(
        "n",
        "<leader>fs",
        builtin.treesitter,
        { desc = "Telescope Treesitter" }
    )
    map("n", "<leader>fr", builtin.resume, { desc = "Telescope Resume" })
    map("n", "<leader>fh", function()
        require("nvchad.themes").open()
    end, { desc = "Telescope Nvchad Themes" })
end

return M
