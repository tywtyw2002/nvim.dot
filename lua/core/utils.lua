local M = {}

local mappings = nil

local function convert_format(maps)
    local r = {}
    for key, info in pairs(maps) do
        local mode = info.mode or "n"
        if r[mode] == nil then
            r[mode] = {}
        end

        r[mode][key] = {nil, info[2]}
    end
    return r
end

-- Convert mapping for cheatsheet
local function get_nv_mappings()
    local mappings = require("as.mappings")
    local results = {}

    for name, maps in pairs(mappings) do
        if type(maps) == "table" then
            if name == "general_mappings" then
                name = "general"
            end
            results[name] = convert_format(maps)
        end
    end

    return results
end

-- Inject Config for base46 Themes
M.load_config = function()
    if mappings == nil then
        mappings = get_nv_mappings()
    end
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
        mappings = mappings,
    }
end

M.load_mappings = function() end

M.set_mapping = function(name, maps)
    if mappings == nil then
        mappings = get_nv_mappings()
    end

    mappings[name] = convert_format(maps)
end
return M
