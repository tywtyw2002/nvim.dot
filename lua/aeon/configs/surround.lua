local M = {}

local default = {
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
    },
}

M.options = function()
    return default
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

return M
