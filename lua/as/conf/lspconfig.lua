as.lsp = {}

local M = {}

-- LSP config
local L = {}

local function lsp_setup_autocommands(client, _)
    if client and client.server_capabilities.CodeLensProvider then
        as.augroup("LspCodeLens", {
            {
                events = { "BufEnter", "CursorHold", "InsertLeave" },
                targets = { "<buffer>" },
                command = vim.lsp.codelens.refresh,
            },
        })
    end
    if client and client.server_capabilities.documentHighlightProvider then
        as.augroup("LspCursorCommands", {
            {
                events = { "CursorHold" },
                targets = { "<buffer>" },
                command = vim.lsp.buf.document_highlight,
            },
            {
                events = { "CursorHoldI" },
                targets = { "<buffer>" },
                command = vim.lsp.buf.document_highlight,
            },
            {
                events = { "CursorMoved" },
                targets = { "<buffer>" },
                command = vim.lsp.buf.clear_references,
            },
        })
    end
end

local function attach_navic(client, bufnr)
    local present, navic = pcall(require, "nvim-navic")

    if present and client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end


L.on_attach = function(client, bufnr)
    lsp_setup_autocommands(client, bufnr)
    attach_navic(client, bufnr)

    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    require("which-key").register(require("as.mappings").lsp)

    --if client.resolved_capabilities.goto_definition then
    --    vim.bo[bufnr].tagfunc = "v:lua.as.lsp.tagfunc"
    --end

    --if client.server_capabilities.signatureHelpProvider then
    --    require("nvchad_ui.signature").setup(client)
    --end
end

L.capabilities = vim.lsp.protocol.make_client_capabilities()

L.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

local LSP_SERVERS = {
    gopls = true,
    pyright = true,
    yamlls = true,
    rust_analyzer = true,
}

LSP_SERVERS.pylsp = {
    capabilities = {
        textDocument = {
            completion = false,
            definition = false,
            documentHighlight = false,
            documentSymbol = false,
            hover = false,
            references = false,
            rename = false,
            signatureHelp = false,
        }
    },
    settings = {
        pylsp = {
            plugins = {
                jedi_completion = { enabled = false },
                jedi_definition = { enabled = false },
                jedi_hover = { enabled = false },
                jedi_references = { enabled = false },
                jedi_signature_help = { enabled = false },
                jedi_symbols = { enabled = false },
            }
        }
    }
}

LSP_SERVERS.lua_ls = function ()
    -- wow lua "/Users/tyw/git/vscode-wow-api/EmmyLua/"
    local library = {}

    for _, path in ipairs({
        "/Users/tyw/git/vscode-wow-api/EmmyLua/"
    }) do
        if vim.fn.isdirectory(path) ~= 0 then
            table.insert(library, path)
        end
    end

    return {
        settings = {
            Lua = {
                diagnostics = {
                    globals = {
                        "vim",
                        "describe",
                        "it",
                        "before_each",
                        "after_each",
                        "pending",
                        "teardown",
                        "packer_plugins",
                    },
                },
                workspace = {
                    library = library,
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
                telemetry = { enable = false },
                completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
            },
        },
    }
end

--[[LSP Configs--]]
M.lsp_config = function()
    dofile(vim.g.base46_cache .. "lsp")
    local lspconfig = require "lspconfig"

    for lsp, conf in pairs(LSP_SERVERS) do
        local conf_type = type(conf)
        local config = conf_type == "table" and conf or conf_type == "function" and conf() or {}
        config.flags = { debounce_text_changes = 500 }
        config.on_attach = L.on_attach
        config.capabilities = config.capabilities or L.capabilities
        lspconfig[lsp].setup(config)
    end

    -- Borders for LspInfo winodw
    local win = require "lspconfig.ui.windows"
    local _default_opts = win.default_opts

    win.default_opts = function(options)
        local opts = _default_opts(options)
        opts.border = "single"
        return opts
    end
end


-- Mason
M.mason_installer = function()
    dofile(vim.g.base46_cache .. "mason")

    local ensure_installed = {
        -- lua
        "lua-language-server",
        "stylua",

        -- python
        "python-lsp-server",
        "pyright",

        --
        "deno",

        "yaml-lsp-server",
        "gopls",
        "rust-analyzer",
    }
    local options = {
        automatic_installation = false,
        ensure_installed = ensure_installed,
        PATH = "skip",
        ui = {
            icons = {
                package_installed = " ",
                package_pending = " ",
                package_uninstalled = " ﮊ",
            },
            keymaps = {
                toggle_server_expand = "<CR>",
                install_server = "i",
                update_server = "u",
                check_server_version = "c",
                update_all_servers = "U",
                check_outdated_servers = "C",
                uninstall_server = "X",
                cancel_installation = "<C-c>",
            },
        },
        max_concurrent_installers = 10,
    }

    vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
    end, {})

    local mason = require("mason")
    mason.setup(options)
end

-- Null LS
M.null_ls = function()
    local null_ls = require("null-ls")
    -- NOTE: this plugin will break if it's dependencies are not installed
    null_ls.setup({
        debounce = 250,
        on_attach = L.on_attach,
        sources = {
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.formatting.stylua.with({
                condition = function(_utils)
                    return as.executable("stylua")
                        and _utils.root_has_file("stylua.toml")
                end,
            }),
            null_ls.builtins.formatting.rustfmt,
            null_ls.builtins.formatting.deno_fmt,
            null_ls.builtins.formatting.prettier.with({
                filetypes = { "html", "json", "yaml", "graphql", "markdown" },
                condition = function()
                    return as.executable("prettier")
                end,
            }),
        },
    })
end

return M
