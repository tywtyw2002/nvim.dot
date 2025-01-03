local M = {}

local default = {}

M.options = function()
    dofile(vim.g.base46_cache .. "whichkey")
    return default
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

return M
