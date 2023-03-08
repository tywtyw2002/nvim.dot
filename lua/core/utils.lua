local M = {}

-- Inject Config for base46 Themes
M.load_config = function()
    return {
        ui = {
            changed_themes = {},
            hl_add = {},
            hl_override = {},
            transparency = false,
            extended_integrations = { "alpha", "bufferline", "notify" },
            -- cmp themeing
            cmp = {
                icons = true,
                lspkind_text = true,
                style = "default", -- default/flat_light/flat_dark/atom/atom_colored
                border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
                selected_item_bg = "colored", -- colored / simple
            },
            statusline = {
                theme = "default",
                separator_style = "default",
                overriden_modules = nil,
            },
            tabufline = {
                enabled = true,
                lazyload = true,
                overriden_modules = nil,
            },
            nvdash = {
                load_on_startup = false,
                header = {},

                buttons = {},
            },

            cheatsheet = {
                theme = "grid", -- simple/grid
            },
        },
    }
end

return M
