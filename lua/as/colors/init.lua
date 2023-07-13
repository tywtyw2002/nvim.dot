local new_cmd = vim.api.nvim_create_user_command

local M = {}

-- if theme given, load given theme if given, otherwise nvchad_theme
M.init = function()
   M.init_cmd()

    local theme_file = vim.g.base46_cache .. "defaults"
    if vim.loop.fs_stat(theme_file) then
        dofile(theme_file)
        return
    end

    local present, base16 = pcall(require, "base46")

    if present then
        base16.load_all_highlights()
    end
end

M.init_cmd = function()
    new_cmd("CompileTheme", function()
        require("base46").load_all_highlights()
    end, {})
end

-- returns a table of colors for given or current theme
M.get = function()
    return require("base46").get_theme_tb "base_30"
end

M.set_transparency = function(status)
    vim.g.transparency = status
    require("base46").load_all_highlights()
end

return M
