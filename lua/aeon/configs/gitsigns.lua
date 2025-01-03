local M = {}

local default = {
    signs = {
        add = { text = "▌" },
        change = { text = "▌" },
        delete = { text = "▌" },
        topdelete = { text = "▌" },
        changedelete = { text = "▌" },
    },
    word_diff = false,
    numhl = false,
}

M.options = function()
    dofile(vim.g.base46_cache .. "git")
    vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'DiffAdd' })
    vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'DiffChange' })
    vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'DiffChange' })
    vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'DiffDelete' })
    vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'DiffChangeDelete' })
    return default
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

return M
