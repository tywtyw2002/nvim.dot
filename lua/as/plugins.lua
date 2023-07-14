local fn = vim.fn
local fmt = string.format

local P = {}

---A thin wrapper around vim.notify to add packer details to the message
---@param msg string
function P.notify(msg, level)
    vim.notify(msg, level, { title = "Lazy" })
end

P.lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

function P.bootstrap()
    print("Bootstrapping lazy.nvim ..")

    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        P.lazypath,
    })

    vim.fn.mkdir(vim.g.base46_cache, "p")
end

---Require a plugin config
---@param name string
---@return any
function P.load_conf(name)
    return require(fmt("as.conf.%s", name))
end

function P.load_conf_as(name, func)
    return function()
        local f = require("as.conf." .. name)
        if func then
            f = f[func]
        end
        f()
    end
end

--P.conf = P.load_conf("other")

function P.conf(name)
    return function()
        local f = require("as.conf.other")
        f[name]()
    end
end

function P.lazy_load(plugin)
    vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
        group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
        callback = function()
            local file = vim.fn.expand("%")
            local condition = file ~= "NvimTree_1"
                and file ~= "[lazy]"
                and file ~= ""

            if condition then
                vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

                -- dont defer for treesitter as it will show slow highlighting
                -- This deferring only happens only when we do "nvim filename"
                if plugin ~= "nvim-treesitter" then
                    vim.schedule(function()
                        require("lazy").load({ plugins = plugin })

                        if plugin == "nvim-lspconfig" then
                            vim.cmd("silent! do FileType")
                        end
                    end, 0)
                else
                    require("lazy").load({ plugins = plugin })
                end
            end
        end,
    })
end

local onBufLoad = { "BufNewFile", "BufRead", "InsertEnter" }

local plugins = {
    { "nvim-lua/plenary.nvim" },

    -- theme
    {
        "NvChad/base46",
        lazy = false,
        branch = "v2.0",
        config = function()
            require("as.colors").init()
        end,
        --build = function()
        --    require("base46").load_all_highlights()
        --end,
    },

    {
        "NvChad/ui",
        branch = "v2.0",
        lazy = false,
        config = function()
            require("nvchad_ui")
            --require('as.features.statusline').hotfix_hl()
            vim.opt.statusline =
                "%!v:lua.require('as.features.statusline').run()"
            --vim.cmd "function! TbToggle_transparency(a,b,c,d) \n lua require('as.colors').toggle_transparency() \n endfunction"
        end,
    },

    {
        "folke/which-key.nvim",
        config = P.load_conf_as("whichkey"),
    },

    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        init = P.load_conf_as("telescope", "setup"),
        config = P.load_conf_as("telescope", "config"),
        dependencies = {
            "telescope-fzf-native.nvim",
            "telescope-frecency.nvim",
            "telescope-tmux.nvim",
        },
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = "tami5/sqlite.lua",
    },
    { "camgraff/telescope-tmux.nvim" },

    -- nvim-web-devicons
    {
        "kyazdani42/nvim-web-devicons",
        config = function()
            dofile(vim.g.base46_cache .. "devicons")
        end,
    },

    -- 'lukas-reineke/indent-blankline.nvim'
    {
        "lukas-reineke/indent-blankline.nvim",
        init = function()
            P.lazy_load("indent-blankline.nvim")
        end,
        config = P.conf("blankline"),
    },

    -- Tree
    {
        "kyazdani42/nvim-tree.lua",
        --ft = "alpha",
        config = P.load_conf_as("nvim-tree", "config"),
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        init = P.load_conf_as("nvim-tree", "setup"),
    },

    -- Tmux navigator
    {
        "christoomey/vim-tmux-navigator",
        config = P.conf("tmux_navigator"),
    },

    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    -- nvim-lsp-installer
    {
        "williamboman/mason.nvim",
        cmd = {
            "Mason",
            "MasonInstall",
            "MasonInstallAll",
            "MasonUninstall",
            "MasonUninstallAll",
            "MasonLog",
        },
        config = P.load_conf_as("lspconfig", "mason_installer"),
    },

    {
        "neovim/nvim-lspconfig",
        init = function()
            P.lazy_load("nvim-lspconfig")
        end,
        config = P.load_conf_as("lspconfig", "lsp_config"),
        dependencies = { "null-ls.nvim", "lsp_signature.nvim" },
    },

    -- null-ls
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = P.load_conf_as("lspconfig", "null_ls"),
    },

    {
        "ray-x/lsp_signature.nvim",
        config = P.conf("lsp_signature"),
    },

    -- trouble
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle" },
        init = function()
            require("which-key").register(require("as.mappings").trouble)
        end,
        dependencies = "nvim-web-devicons",
        config = P.load_conf_as("trouble", "config"),
    },

    -----------------------------------------------------------------------------//
    -- CMP
    -----------------------------------------------------------------------------//
    -- CMP
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "cmp-nvim-lua",
            "cmp-nvim-lsp",
            "cmp-buffer",
            "cmp-path",
            -- with configs
            "L3MON4D3/LuaSnip",
            "windwp/nvim-autopairs",
        },
        event = { "InsertEnter" },
        config = P.load_conf_as("cmp"),
    },

    { "saadparwaiz1/cmp_luasnip" },

    { "hrsh7th/cmp-nvim-lua" },

    { "hrsh7th/cmp-nvim-lsp" },

    { "hrsh7th/cmp-buffer" },

    { "hrsh7th/cmp-path" },

    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        config = P.conf("luasnip"),
        dependencies = { "friendly-snippets" },
    },

    -- friendly-snippets
    { "rafamadriz/friendly-snippets" },

    -----------------------------------------------------------------------------//
    -- UI
    -----------------------------------------------------------------------------//
    -- Scrollbar
    {
        "petertriho/nvim-scrollbar",
        event = onBufLoad,
        config = P.conf("scrollbar"),
    },

    -- goolord/alpha-nvim
    --{
    --    "goolord/alpha-nvim",
    --    lazy = false,
    --    config = P.load_conf_as("alpha", "config"),
    --    --init = P.load_conf_as("alpha", "setup"),
    --},

    -- Standalone UI for nvim-lsp progress.
    {
        "j-hui/fidget.nvim",
        enabled = false,
        config = function()
            require("fidget").setup({})
        end,
    },

    -- Tab bufferline
    --{
    --    "akinsho/bufferline.nvim",
    --    branch = "main",
    --    dependencies = "nvim-web-devicons",
    --    event = { "BufAdd", "BufEnter", "tabnew" },
    --    config = P.load_conf_as("bufferline", "config"),
    --    init = P.load_conf_as("bufferline", "setup"),
    --},

    -- feline
    --{
    --    "feline-nvim/feline.nvim",
    --    lazy = false,
    --    dependencies = "nvim-web-devicons",
    --    config = P.load_conf_as("feline"),
    --},

    -- SmiteshP/nvim-navic
    {
        "SmiteshP/nvim-navic",
        event = "CursorMoved",
        config = P.load_conf_as("gps"),
    },

    -----------------------------------------------------------------------------//
    -- Editor
    -----------------------------------------------------------------------------//
    -- "andymass/vim-matchup",

    -- "surround.nvim",
    {
        "kylechui/nvim-surround",
        event = onBufLoad,
        config = P.conf("surround"),
    },

    -- easymotion phaazon/hop.nvim
    {
        "phaazon/hop.nvim",
        config = P.load_conf_as("hop"),
        event = onBufLoad,
    },

    -- comment
    {
        "numToStr/Comment.nvim",
        keys = { "gc", "gb" },
        config = P.conf("comment"),
        init = function()
            require("which-key").register(require("as.mappings").comment)
        end,
    },

    -- mini (Tailspace)
    {
        "echasnovski/mini.nvim",
        config = P.conf("trailspace"),
        event = onBufLoad,
        init = function()
            require("which-key").register(require("as.mappings").trailspace)
        end,
    },

    "andymass/vim-matchup",
    --------------------------------------------------------------------------------
    -- Utilitiess
    --------------------------------------------------------------------------------
    -- Hex color display
    {
        --"norcalli/nvim-colorizer.lua",
        "NvChad/nvim-colorizer.lua",
        init = function()
            P.lazy_load("nvim-colorizer.lua")
        end,
        config = P.conf("colorizer"),
    },

    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = "<leader>u",
        init = function()
            require("which-key").register(require("as.mappings").undotree)
        end,
        config = P.conf("undotree"),
    },

    --"windwp/nvim-autopairs"
    {
        "windwp/nvim-autopairs",
        --event = "InsertEnter",
        config = P.conf("autopairs"),
    },

    {
        "rcarriga/nvim-notify",
        config = P.conf("notify"),
    },

    {
        "NvChad/nvterm",
        config = P.conf("nvterm"),
        init = function()
            require("which-key").register(require("as.mappings").nvterm)
        end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = "plenary.nvim",
        init = function()
            P.lazy_load("todo-comments.nvim")
        end,
        config = P.conf("todo_comments"),
    },

    --------------------------------------------------------------------------------
    -- Profiling & Startup
    --------------------------------------------------------------------------------
    -- filetype
    --{ "nathom/filetype.nvim" },

    { "folke/neodev.nvim", enabled = false },
    "elzr/vim-json",
    "cespare/vim-toml",
    "plasticboy/vim-markdown",
    --use 'uarun/vim-protobuf'
    --use 'rust-lang/rust.vim'
    --use 'fatih/vim-go'
    --use 'pangloss/vim-javascript'
    --use 'leafgarland/typescript-vim'
    --use 'peitalin/vim-jsx-typescript'
    "mtdl9/vim-log-highlighting",
    "baskerville/vim-sxhkdrc",

    -- speed profiling
    -- dstein64/vim-startuptime
    --------------------------------------------------------------------------------
    -- Syntax
    --------------------------------------------------------------------------------
    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        init = function()
            P.lazy_load("nvim-treesitter")
        end,
        build = ":TSUpdate",
        event = onBufLoad,
        config = P.load_conf_as("treesitter"),
        dependencies = {
            "nvim-ts-rainbow",
            "nvim-treesitter-textobjects",
        },
    },

    { "p00f/nvim-ts-rainbow" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    {
        "nvim-treesitter/playground",
        enabled = false,
        keys = "<leader>E",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
        init = function()
            require("which-key").register({
                ["<leader>E"] = "treesitter: highlight cursor group",
            })
        end,
        config = function()
            as.nnoremap("<leader>E", "<Cmd>TSHighlightCapturesUnderCursor<CR>")
        end,
    },

    --------------------------------------------------------------------------------
    -- Git
    --------------------------------------------------------------------------------
    {
        "lewis6991/gitsigns.nvim",
        ft = "gitcommit",
        init = function()
            -- load gitsigns only when a git file is opened
            vim.api.nvim_create_autocmd({ "BufRead" }, {
                group = vim.api.nvim_create_augroup(
                    "GitSignsLazyLoad",
                    { clear = true }
                ),
                callback = function()
                    vim.fn.system(
                        "git -C " .. vim.fn.expand("%:p:h") .. " rev-parse"
                    )
                    if vim.v.shell_error == 0 then
                        vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
                        vim.schedule(function()
                            require("lazy").load({ plugins = "gitsigns.nvim" })
                        end)
                    end
                end,
            })
        end,
        config = P.load_conf_as("gitsigns"),
    },

    -- conflict-marker.vim
    -- TODO: https://github.com/akinsho/git-conflict.nvim
    --{
    --    "rhysd/conflict-marker.vim",
    --    config = P.conf("conflict_marker"),
    --},
}

local lazy_config = {
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

if not vim.loop.fs_stat(P.lazypath) then
    P.bootstrap()
end

vim.opt.rtp:prepend(P.lazypath)

require("lazy").setup(plugins, lazy_config)
