local M = {}
local map = vim.keymap.set

local LSP_SERVERS = {
    nil_ls = true,
    rust_analyzer = true,
    gopls = true,
    pyright = true,
}

LSP_SERVERS.lua_ls = function()
    local library = {
        vim.fn.expand("$VIMRUNTIME/lua"),
        -- vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
    }

    for _, path in ipairs({
        "/Users/tyw/git/vscode-wow-api/EmmyLua/",
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
            },
        },
    }
end

-- lsp related
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
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

local function attach_navic(client, bufnr)
    local present, navic = pcall(require, "nvim-navic")

    if present and client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

M.on_init = function(client, _)
    if client.supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
    end

    -- disable formatting
    -- client.server_capabilities.documentFormattingProvider = false
    -- client.server_capabilities.documentRangeFormattingProvider = false
end

M.on_attach = function(client, bufnr)
    attach_navic(client, bufnr)
    -- add keybinds
    M.keybinds()
end

M.do_config = function()
    dofile(vim.g.base46_cache .. "lsp")
    require("nvchad.lsp").diagnostic_config()

    local lspconfig = require("lspconfig")

    for lsp, conf in pairs(LSP_SERVERS) do
        local conf_type = type(conf)
        local config = conf_type == "table" and conf
            or conf_type == "function" and conf()
            or {}
        config.flags = { debounce_text_changes = 500 }
        config.on_attach = M.on_attach
        config.on_init = M.on_init
        config.capabilities = config.capabilities or M.capabilities
        lspconfig[lsp].setup(config)
    end
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

M.keybinds = function()
    local map = vim.keymap.set
    map(
        "n",
        "gD",
        "<cmd>lua vim.lsp.buf.declaration()<CR>",
        { desc = "LSP Goto Declaration" }
    )
    map(
        "n",
        "gd",
        "<cmd>lua vim.lsp.buf.definition()<CR>",
        { desc = "LSP Goto Definition" }
    )
    map(
        "n",
        "gr",
        "<cmd>lua vim.lsp.buf.references()<CR>",
        { desc = "LSP Goto References" }
    )
    map(
        "n",
        "gi",
        "<cmd>lua vim.lsp.buf.implementation()<CR>",
        { desc = "LSP Goto Implementation" }
    )
    map(
        "n",
        "gI",
        "<cmd>lua vim.lsp.buf.incoming_calls()<CR>",
        { desc = "LSP Goto Incoming Calls" }
    )
    map(
        "n",
        "gy",
        "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        { desc = "LSP Goto Implementation" }
    )
    map(
        "n",
        "gk",
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        { desc = "LSP Signature Help" }
    )
    map(
        "n",
        "<leader>ra",
        "<cmd>lua vim.lsp.buf.rename()<CR>",
        { desc = "LSP Rename" }
    )
    map(
        { "n", "x" },
        "<leader>ca",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        { desc = "LSP Code Action" }
    )
    map(
        "n",
        "ge",
        "<cmd>lua vim.diagnostic.open_float()<CR>",
        { desc = "LSP Show Diagnostics" }
    )
    map(
        "n",
        "[d",
        "<cmd>lua vim.diagnostic.goto_prev()<CR>",
        { desc = "LSP Prev Diagnostic" }
    )
    map(
        "n",
        "]d",
        "<cmd>lua vim.diagnostic.goto_next()<CR>",
        { desc = "LSP Next Diagnostic" }
    )
    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "LSP Hover" })
end

return M
