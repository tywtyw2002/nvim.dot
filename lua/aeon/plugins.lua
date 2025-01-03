local helper = require("aeon.core.helper")

return {
    { "nvim-lua/plenary.nvim" },

    {
        "NvChad/base46",
        build = function()
            require("base46").load_all_highlights()
        end,
    },
    {
        "NvChad/ui",
        lazy = false,
        config = function()
            require("nvchad")
            local lsp_au = vim.api.nvim_get_autocmds({
                event = "LspProgress",
                pattern = { "begin", "end" },
            })
            for _, v in pairs(lsp_au) do
                vim.api.nvim_del_autocmd(v.id)
                break
            end
            -- vim.api.nvim_del_autocmd("LspProgress")
            -- vim.api.nvim_del_user_command("MasonInstallAll")
        end,
    },

    "nvzone/volt",
    "nvzone/menu",
    { "nvzone/minty",         cmd = { "Huefy", "Shades" } },

    {
        "nvim-tree/nvim-web-devicons",
        opts = function()
            dofile(vim.g.base46_cache .. "devicons")
            return { override = require("nvchad.icons.devicons") }
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "User FilePost",
        config = helper.get_misc_config("blankline"),
    },

    -- file managing , picker etc
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        opts = helper.get_plugin_options("nvimtree", true),
    },

    -- which-key
    {
        "folke/which-key.nvim",
        keys = { "<leader>" },
        cmd = "WhichKey",
        opts = helper.get_plugin_options("whichkey", true),
    },

    -- formatting!
    {
        "stevearc/conform.nvim",
        opts = helper.get_plugin_options("conform", true),
    },

    -- git stuff
    {
        "lewis6991/gitsigns.nvim",
        event = "User FilePost",
        opts = helper.get_plugin_options("gitsigns", true),
    },

    -- lsp
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
        opts = helper.get_plugin_options("mason", true),
    },

    {
        "neovim/nvim-lspconfig",
        event = "User FilePost",
        config = require("aeon.configs.lspconfig").do_config,
    },

    -- {
    --     "ray-x/lsp_signature.nvim",
    --     event = "InsertEnter",
    --     opts = {
    --         bind = true,
    --         handler_opts = {
    --             border = "single"
    --         }
    --     },
    --     config = function(_, opts) require 'lsp_signature'.setup(opts) end
    -- },

    -- load luasnips + cmp related in insert mode only
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                -- snippet plugin
                "L3MON4D3/LuaSnip",
                dependencies = "rafamadriz/friendly-snippets",
                opts = {
                    history = true,
                    updateevents = "TextChanged,TextChangedI",
                },
                config = function(_, opts)
                    require("luasnip").config.set_config(opts)
                    require("aeon.configs.luasnips").init()
                end,
            },

            -- autopairing of (){}[] etc
            {
                "windwp/nvim-autopairs",
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
                config = function(_, opts)
                    require("nvim-autopairs").setup(opts)

                    -- setup cmp for autopairs
                    local cmp_autopairs =
                        require("nvim-autopairs.completion.cmp")
                    require("cmp").event:on(
                        "confirm_done",
                        cmp_autopairs.on_confirm_done()
                    )
                end,
            },

            -- cmp sources plugins
            {
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
            },
        },
        opts = helper.get_plugin_options("cmp", true),
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "telescope-fzf-native.nvim",
        },
        cmd = "Telescope",
        opts = helper.get_plugin_options("telescope", true),
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate",
        opts = helper.get_plugin_options("treesitter", true),
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    },

    -- plguins
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle" },
        opts = helper.get_plugin_options("trouble", true),
    },

    -- Standalone UI for nvim-lsp progress.
    {
        "j-hui/fidget.nvim",
        opts = {},
    },

    {
        "SmiteshP/nvim-navic",
        event = "CursorMoved",
        opts = {
            depth_limit = 5,
        },
    },

    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = helper.get_plugin_options("surround", true),
    },

    -- comment
    {
        "numToStr/Comment.nvim",
        keys = { "gc", "gb" },
        opts = helper.get_plugin_options("comment", true),
    },

    { "echasnovski/mini.trailspace" },
}
