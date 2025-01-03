local M = {
    ui = {},
}

M.base46 = {
    theme = "everblush",
    transparency = false,
}

M.ui.statusline = {
    enabled = true,
    style = "default",
}

M.ui.telescope = { style = "borderless" }

M.nvdash = {
    load_on_startup = true,
    header = {
        "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
        "   ▄▀███▄     ▄██ █████▀    ",
        "   ██▄▀███▄   ███           ",
        "   ███  ▀███▄ ███           ",
        "   ███    ▀██ ███           ",
        "   ███      ▀ ███           ",
        "   ▀██ █████▄▀█▀▄██████▄    ",
        "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
    },

    buttons = {
        { txt = "  New File  ", keys = "nb", cmd = "ene" },
        { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
        { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
        -- { "  Bookmarks  ", "SPC b m", "Telescope marks" },

        {
            txt = "󱥚  Themes",
            keys = "th",
            cmd = ":lua require('nvchad.themes').open()",
        },
        -- { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

        { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
        {
            txt = function()
                local stats = require("lazy").stats()
                local ms = math.floor(stats.startuptime) .. " ms"
                return "  Loaded "
                    .. stats.loaded
                    .. "/"
                    .. stats.count
                    .. " plugins in "
                    .. ms
            end,
            hl = "NvDashFooter",
            no_gap = true,
        },

        { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    },
}

M.lsp = {}

return M
