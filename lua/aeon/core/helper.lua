local M = {}

function M.get_misc_config(name)
    return function()
        local f = require("aeon.configs.alot")
        f[name]()
    end
end

function M.get_plugin_options(name, as_function)
    local f = require("aeon.configs." .. name)
    local options = f.options

    if as_function then
        return type(options) == "function" and options
            or function()
                return options
            end
    end

    return options
end

function M.multi_map(mode, lhs, rhs, opts)
    for _, m in ipairs(mode) do
        vim.keymap.set(m, lhs, rhs, opts)
    end
end

return M
