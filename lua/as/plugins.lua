local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath("cache")
    .. "/packer/packer_compiled.lua"

local P = {}

---A thin wrapper around vim.notify to add packer details to the message
---@param msg string
function P.packer_notify(msg, level)
    vim.notify(msg, level, { title = "Packer" })
end

---Require a plugin config
---@param name string
---@return any
function P.load_conf(name)
    return require(fmt("as.conf.%s", name))
end

function P.load_conf_as(name, func)
    local r = ""
    if func then
        r = "." .. func
    end
    return "require" .. fmt("('as.conf.%s')", name) .. r .. "()"
end

--P.conf = P.load_conf("other")

function P.conf(name)
    return "require" .. fmt("('as.conf.other').%s()", name)
end

function P.lazy_load(plugin)
    vim.defer_fn(function()
        require("packer").loader(plugin)
    end, 0)
end

-- packer bootstrap
function P.bootstrap_packer()
    local packer_path = vim.fn.stdpath("data")
        .. "/site/pack/packer/opt/packer.nvim"

    print("Cloning packer..")
    -- remove the dir before cloning
    vim.fn.delete(packer_path, "rf")
    vim.fn.system({
        "git",
        "clone",
        "https://github.com/wbthomason/packer.nvim",
        "--depth",
        "20",
        packer_path,
    })

    vim.cmd("packadd packer.nvim")
    present, packer = pcall(require, "packer")

    if present then
        print("Packer cloned successfully.")
    else
        error(
            "Couldn't clone packer !\nPacker path: "
                .. packer_path
                .. "\n"
                .. packer
        )
    end

    return packer
end

pcall(vim.cmd, "packadd packer.nvim")
local present, packer = pcall(require, "packer")

if not present then
    packer = P.bootstrap_packer()
end

packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "single" })
        end,
        prompt_border = "single",
        working_sym = " ﲊ",
        error_sym = "✗ ",
        done_sym = " ",
        removed_sym = " ",
        moved_sym = "",
    },
    auto_clean = true,
    compile_on_sync = true,
    git = { clone_timeout = 6000 },
    luarocks = {
        python_cmd = "python3",
    },
    --log = { level = 'debug'}
})

--local onBufLoad = { "BufNewFile", "BufRead", "InsertEnter" }
local onBufLoad = "User FileOpened"

packer.startup({
    function(use, use_rocks)
        --use({"wbthomason/packer.nvim", opt = true })
        use({ "wbthomason/packer.nvim", event = "VimEnter" })

        use_rocks("penlight")

        use_rocks("luautf8")

        use({ "tami5/sqlite.lua" })

        -- 'nvim-lua/plenary.nvim'
        use({ "nvim-lua/plenary.nvim" })

        -- startup cache
        use("lewis6991/impatient.nvim")

        -- theme
        use({
            "NvChad/base46",
            after = "plenary.nvim",
            commit = "f39d712a915b837fe34bb74ab880a1879fc6eaf1",
            config = function()
                require("as.colors").init()
            end,
        })

        -- telescope
        use({
            "nvim-telescope/telescope.nvim",
            cmd = "Telescope",
            module_pattern = "telescope.*",
            setup = P.load_conf_as("telescope", "setup"),
            config = P.load_conf_as("telescope", "config"),
            requires = P.load_conf("telescope").requires,
        })

        -- nvim-web-devicons
        use({
            "kyazdani42/nvim-web-devicons",
            after = "base46",
        })

        use({
            "folke/which-key.nvim",
            config = P.load_conf_as("whichkey"),
        })

        -- 'lukas-reineke/indent-blankline.nvim'
        use({
            "lukas-reineke/indent-blankline.nvim",
            opt = true,
            event = onBufLoad,
            config = P.conf("blankline"),
        })

        -- Tree
        use({
            "kyazdani42/nvim-tree.lua",
            ft = "alpha",
            config = P.load_conf_as("nvim-tree", "config"),
            --requires = "nvim-web-devicons",
            cmd = { "NvimTreeToggle", "NvimTreeFocus" },
            setup = P.load_conf_as("nvim-tree", "setup"),
        })

        -- Tmux navigator
        use({
            "christoomey/vim-tmux-navigator",
            config = P.conf("tmux_navigator"),
        })

        -----------------------------------------------------------------------------//
        -- LSP
        -----------------------------------------------------------------------------//
        -- nvim-lsp-installer
        use({
            "williamboman/mason.nvim",
            --opt = true,
            cmd = {
                "Mason",
                "MasonInstall",
                "MasonInstallAll",
                "MasonUninstall",
                "MasonUninstallAll",
                "MasonLog",
            },
            config = P.load_conf_as("lspconfig", "mason_installer"),
        })

        use({
            "neovim/nvim-lspconfig",
            opt = true,
            event = onBufLoad,
            config = P.load_conf_as("lspconfig", "lsp_config"),
        })

        -- null-ls
        use({
            "jose-elias-alvarez/null-ls.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            -- trigger loading after lspconfig has started the other servers
            -- since there is otherwise a race condition and null-ls' setup would
            -- have to be moved into lspconfig.lua otherwise
            config = P.load_conf_as("lspconfig", "null_ls"),
        })

        use({
            "ray-x/lsp_signature.nvim",
            config = P.conf("lsp_signature"),
            after = "nvim-lspconfig",
        })

        -- trouble
        use({
            "folke/trouble.nvim",
            cmd = { "TroubleToggle" },
            setup = "require('which-key').register(require('as.mappings').trouble)",
            requires = "nvim-web-devicons",
            config = P.load_conf_as("trouble", "config"),
        })

        -----------------------------------------------------------------------------//
        -- CMP
        -----------------------------------------------------------------------------//
        -- CMP
        use({
            "hrsh7th/nvim-cmp",
            wants = {
                "cmp_luasnip",
                "cmp-nvim-lua",
                "cmp-nvim-lsp",
                "cmp-buffer",
                "cmp-path",
            },
            event = { "InsertEnter" },
            config = P.load_conf_as("cmp"),
        })

        use({ "saadparwaiz1/cmp_luasnip", opt = true })

        use({ "hrsh7th/cmp-nvim-lua", opt = true })

        use({ "hrsh7th/cmp-nvim-lsp", opt = true })

        use({ "hrsh7th/cmp-buffer", opt = true })

        use({ "hrsh7th/cmp-path", opt = true })

        use({
            "L3MON4D3/LuaSnip",
            event = "InsertEnter",
            config = P.conf("luasnip"),
            wants = { "friendly-snippets" }
        })

        -- friendly-snippets
        use({
            "rafamadriz/friendly-snippets",
            --module = { "cmp", "cmp_nvim_lsp" },
            opt = true
        })

        -----------------------------------------------------------------------------//
        -- UI
        -----------------------------------------------------------------------------//
        -- Scrollbar
        use({
            "petertriho/nvim-scrollbar",
            event = onBufLoad,
            config = P.conf("scrollbar"),
        })

        -- goolord/alpha-nvim
        use({
            "goolord/alpha-nvim",
            config = P.load_conf_as("alpha", "config"),
            setup = P.load_conf_as("alpha", "setup"),
        })

        -- Standalone UI for nvim-lsp progress.
        use({
            "j-hui/fidget.nvim",
            disable = true,
            config = function()
                require("fidget").setup({})
            end,
        })

        -- Tab bufferline
        use({
            "akinsho/bufferline.nvim",
            branch = "main",
            after = "nvim-web-devicons",
            config = P.load_conf_as("bufferline", "config"),
            setup = P.load_conf_as("bufferline", "setup"),
        })

        -- feline
        use({
            "feline-nvim/feline.nvim",
            after = "nvim-web-devicons",
            config = P.load_conf_as("feline"),
        })

        use({
            "SmiteshP/nvim-gps",
            event = "CursorMoved",
            config = P.load_conf_as("gps"),
        })

        -----------------------------------------------------------------------------//
        -- Editor
        -----------------------------------------------------------------------------//
        -- "andymass/vim-matchup",

        -- "surround.nvim",
        use({
            "tywtyw2002/surround.nvim",
            event = onBufLoad,
            config = function()
                require("surround").setup({
                    mappings_style = "surround",
                    map_insert_mode = false,
                })
            end,
        })

        -- easymotion phaazon/hop.nvim
        use({
            "phaazon/hop.nvim",
            keys = { { "n", "s" }, "f", "F", { "n", "/" } },
            config = P.load_conf_as("hop"),
        })

        -- comment
        use({
            "numToStr/Comment.nvim",
            module = "Comment",
            keys = { "gc", "gb" },
            config = P.conf("comment"),
            setup = 'require("which-key").register(require("as.mappings").comment)',
        })

        -- mini (Tailspace)
        use({
            "echasnovski/mini.nvim",
            config = P.conf("trailspace"),
            event = onBufLoad,
            setup = 'require("which-key").register(require("as.mappings").trailspace)',
        })

        use("andymass/vim-matchup")
        --------------------------------------------------------------------------------
        -- Utilitiess
        --------------------------------------------------------------------------------
        -- Hex color display
        use({
            "norcalli/nvim-colorizer.lua",
            opt = true,
            event = onBufLoad,
            config = P.conf("colorizer"),
        })

        use({
            "mbbill/undotree",
            cmd = "UndotreeToggle",
            keys = "<leader>u",
            --setup = P.conf("undotree_setup"),
            setup = "require('which-key').register(require('as.mappings').undotree)",
            config = P.conf("undotree"),
        })

        --"windwp/nvim-autopairs"
        use({
            "windwp/nvim-autopairs",
            after = { "nvim-cmp" },
            config = P.conf("autopairs"),
        })

        -- "max397574/better-escape.nvim",
        use({
            "max397574/better-escape.nvim",
            event = "InsertCharPre",
            config = P.conf("better_escape"),
        })

        use({
            "rcarriga/nvim-notify",
            config = P.conf("notify"),
        })

        use({
            "NvChad/nvterm",
            config = P.conf("nvterm"),
            setup = "require('which-key').register(require('as.mappings').nvterm)",
        })

        --------------------------------------------------------------------------------
        -- Profiling & Startup
        --------------------------------------------------------------------------------
        -- filetype
        use({ "nathom/filetype.nvim" })

        use({
            "folke/neodev.nvim",
            --config = "require('neodev').setup()"
        })
        use("elzr/vim-json")
        use("cespare/vim-toml")
        use("plasticboy/vim-markdown")
        --use 'uarun/vim-protobuf'
        --use 'rust-lang/rust.vim'
        --use 'fatih/vim-go'
        --use 'pangloss/vim-javascript'
        --use 'leafgarland/typescript-vim'
        --use 'peitalin/vim-jsx-typescript'
        use("mtdl9/vim-log-highlighting")

        -- speed profiling
        -- dstein64/vim-startuptime
        --------------------------------------------------------------------------------
        -- Syntax
        --------------------------------------------------------------------------------
        -- treesitter
        use({
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            event = onBufLoad,
            config = P.load_conf_as("treesitter"),
        })

        use({ "p00f/nvim-ts-rainbow", after = "nvim-treesitter" })
        use({
            "nvim-treesitter/nvim-treesitter-textobjects",
            after = "nvim-treesitter",
        })
        use({
            "nvim-treesitter/playground",
            disable = true,
            keys = "<leader>E",
            cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
            setup = function()
                require("which-key").register({
                    ["<leader>E"] = "treesitter: highlight cursor group",
                })
            end,
            config = function()
                as.nnoremap(
                    "<leader>E",
                    "<Cmd>TSHighlightCapturesUnderCursor<CR>"
                )
            end,
        })

        --[[    -- Use <Tab> to escape from pairs such as ""|''|() etc.
          use {
          'abecodes/tabout.nvim',
          wants = { 'nvim-treesitter' },
          --after = { 'nvim-cmp' },
          config = function()
            require('tabout').setup {
            completion = false,
            ignore_beginning = false,
            }
          end,
          }
        --]]
        --------------------------------------------------------------------------------
        -- Git
        --------------------------------------------------------------------------------
        use({
            "lewis6991/gitsigns.nvim",
            event = "BufRead",
            config = P.load_conf_as("gitsigns"),
        })

        -- gitlinker fugitive
        --use {
        --  "ruifm/gitlinker.nvim",
        --  requires = "plenary.nvim",
        --  keys = {"<localleader>gu", "<localleader>go"},
        --  setup = function()
        --    require("which-key").register(
        --      {gu = "gitlinker: get line url", go = "gitlinker: open repo url"},
        --      {prefix = "<localleader>"}
        --    )
        --  end,
        --  config = function()
        --    local linker = require "gitlinker"
        --    linker.setup {mappings = "<localleader>gu"}
        --    as.nnoremap(
        --      "<localleader>go",
        --      function()
        --        linker.get_repo_url {action_callback = require("gitlinker.actions").open_in_browser}
        --      end
        --    )
        --  end
        --}

        -- conflict-marker.vim
        use({
            "rhysd/conflict-marker.vim",
            config = P.conf("conflict_marker"),
        })

        use("baskerville/vim-sxhkdrc")
        --  "TimUntersberger/neogit",
    end,
    log = { level = "info" },
    config = {
        compile_path = PACKER_COMPILED_PATH,
        display = {
            prompt_border = "rounded",
            open_cmd = "silent topleft 65vnew",
        },
        profile = {
            enable = true,
            threshold = 1,
        },
    },
})

as.command({
    "PackerCompiledEdit",
    function()
        vim.cmd(fmt("edit %s", PACKER_COMPILED_PATH))
    end,
})

as.command({
    "PackerCompiledDelete",
    function()
        vim.fn.delete(PACKER_COMPILED_PATH)
        P.packer_notify(fmt("Deleted %s", PACKER_COMPILED_PATH))
    end,
})

if
    not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH)
then
    as.source(PACKER_COMPILED_PATH)
    vim.g.packer_compiled_loaded = true
end

as.nnoremap("<leader>ps", [[<Cmd>PackerSync<CR>]])
as.nnoremap("<leader>pc", [[<Cmd>PackerClean<CR>]])
