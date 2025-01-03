local M = {}

local default = {
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        nix = { "alejandra", "nixpkgs-fmt" },
    },
}

M.options = function()
    return default
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

return M
