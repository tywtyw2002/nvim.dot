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
                separator_style = {
                    left = "",
                    right = "",
                },
                overriden_modules = nil,
            },
            tabufline = {
                enabled = true,
                lazyload = false,
                overriden_modules = function(M)
                    local buttons = function()
                        local toggle_transparency_Btn = "%@TbToggle_transparency@%#TbLineThemeToggleBtn#" .. vim.g.toggle_theme_icon .. " %X"
                        local close_btn = "%@TbCloseAllBufs@%#TbLineCloseAllBufsBtn#"
                            .. " "
                            .. "%X"
                        return toggle_transparency_Btn .. close_btn
                    end
                    table.remove(M, 4)
                    table.insert(M, buttons())
                end,
            },
            nvdash = {
                load_on_startup = true,
                header = {
                    "           ▄ ▄                   ",
                    "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
                    "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
                    "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
                    "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
                    "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
                    "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
                    "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
                    "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
                },

                buttons = {
                    { "  New File  ", "SPC n b", "ene" },
                    { "  Find File  ", "SPC f f", "Telescope find_files" },
                    { "  Recents  ", "SPC f o", "Telescope oldfiles" },
                    { "  Find Word  ", "SPC f w", "Telescope live_grep" },
                    { "  Bookmarks  ", "SPC b m", "Telescope marks" },
                },
            },

            cheatsheet = {
                theme = "grid", -- simple/grid
            },

            telescope = {
                style = "borderless",
            },
        },
    }
end

M.load_mappings = function() end

return M
