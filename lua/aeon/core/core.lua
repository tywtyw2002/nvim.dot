-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- load statusline
require("aeon.features.statusline").hotfix_hl()
-- vim.api.nvim_del_autocmd("LspProgress")
vim.opt.statusline = "%!v:lua.require('aeon.features.statusline').run()"

-- nvchad cmds
-- remove old mason install command
vim.schedule(function()
    vim.api.nvim_del_user_command("MasonInstallAll")
    vim.api.nvim_create_user_command("MasonInstallAll", function()
        print("Installing Mason plugins...")
        vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
    end, {})
end)

vim.api.nvim_create_user_command("ChangeThemes", function()
    require("nvchad.themes").open()
end, {})

-- load options
require("aeon.options")

-- do auto commands
-- vim.schedule(function()
require("aeon.core.au")
-- end)
