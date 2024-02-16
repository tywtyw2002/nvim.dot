local M = {}

local copilot_default = {
    panel = {
        enabled = false
    },
    suggestion = {
        enabled = false
    },
    filetypes = {
        ["*"] = false
    }
}

M.copilot_config = function()
    local present, copilot = pcall(require, "copilot")

    if not present then
        return
    end

    copilot.setup(copilot_default)
end

M.copilot_cmp = function()
    local present, copilot_cmp = pcall(require, "copilot_cmp")

    if not present then
        return
    end

    copilot_cmp.setup()
end


return M