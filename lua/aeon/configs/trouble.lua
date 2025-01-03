local M = {}

local default = {
    { auto_close = true, auto_preview = false },
}

M.options = function()
    return default
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

M.keybinds = function()
    local map = vim.keymap.set
    map(
        "n",
        "<leader>ld",
        "<cmd>Trouble diagnostics toggle<CR>",
        { desc = "Trouble Toggle" }
    )
    map(
        "n",
        "<leader>lq",
        "<cmd>Trouble quickfix toggle<CR>",
        { desc = "Trouble Quickfix" }
    )
end

return M
