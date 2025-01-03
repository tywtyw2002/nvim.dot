local config = {
    defaults = { lazy = true },
    ui = {
        icons = {
            start = "",
            cmd = "",
            event = "ﯓ",
            ft = "",
            lazy = "鈴 ",
            loaded = "",
            not_loaded = "",
        },
    },

    performance = {
        rtp = {
            paths = { vim.g.dotpath },
            disabled_plugins = {
                "2html_plugin",
                "tohtml",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "netrw",
                "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",
                "matchit",
                "tar",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "tutor",
                "rplugin",
                "syntax",
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
            },
        },
    },
}

return config
