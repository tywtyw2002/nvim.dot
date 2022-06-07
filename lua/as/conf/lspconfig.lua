as.lsp = {}

local M = {}
-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//
local function setup_autocommands(client, _)
    if client and client.resolved_capabilities.code_lens then
        as.augroup("LspCodeLens", {
            {
                events = { "BufEnter", "CursorHold", "InsertLeave" },
                targets = { "<buffer>" },
                command = vim.lsp.codelens.refresh,
            },
        })
    end
    if client and client.resolved_capabilities.document_highlight then
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
    -- disable autoformat!!!
    --if client and client.resolved_capabilities.document_formatting then
    --  -- format on save
    --  as.augroup('LspFormat', {
    --    {
    --      events = { 'BufWritePre' },
    --      targets = { '<buffer>' },
    --      command = function()
    --        -- BUG: folds are are removed when formatting is done, so we save the current state of the
    --        -- view and re-apply it manually after formatting the buffer
    --        -- @see: https://github.com/nvim-treesitter/nvim-treesitter/issues/1424#issuecomment-909181939
    --        vim.cmd 'mkview!'
    --        vim.lsp.buf.formatting_sync()
    --        vim.cmd 'loadview'
    --      end,
    --    },
    --  })
    --end
end

vim.lsp.buf.rename = {
    float = function()
        local currName = vim.fn.expand("<cword>")

        local win = require("plenary.popup").create("  ", {
            title = currName,
            style = "minimal",
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            relative = "cursor",
            borderhighlight = "RenamerBorder",
            titlehighlight = "RenamerTitle",
            focusable = true,
            width = 25,
            height = 1,
            line = "cursor+2",
            col = "cursor-1",
        })

        local map_opts = { noremap = true, silent = true }

        vim.cmd("startinsert")

        vim.api.nvim_buf_set_keymap(0, "i", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)

        vim.api.nvim_buf_set_keymap(
            0,
            "i",
            "<CR>",
            "<cmd>stopinsert | lua vim.lsp.buf.rename.apply(" .. currName .. "," .. win .. ")<CR>",
            map_opts
        )

        vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<CR>",
            "<cmd>stopinsert | lua vim.lsp.buf.rename.apply(" .. currName .. "," .. win .. ")<CR>",
            map_opts
        )
    end,

    apply = function(curr, win)
        local newName = vim.trim(vim.fn.getline("."))
        vim.api.nvim_win_close(win, true)

        if #newName > 0 and newName ~= curr then
            local params = vim.lsp.util.make_position_params()
            params.newName = newName

            vim.lsp.buf_request(0, "textDocument/rename", params)
        end
    end,
}

function as.lsp.tagfunc(pattern, flags)
    if flags ~= "c" then
        return vim.NIL
    end
    local params = vim.lsp.util.make_position_params()
    local client_id_to_results, err = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 500)
    assert(not err, vim.inspect(err))

    local results = {}
    for _, lsp_results in ipairs(client_id_to_results) do
        for _, location in ipairs(lsp_results.result or {}) do
            local start = location.range.start
            table.insert(results, {
                name = pattern,
                filename = vim.uri_to_fname(location.uri),
                cmd = string.format("call cursor(%d, %d)", start.line + 1, start.character + 1),
            })
        end
    end
    return results
end

function as.lsp.on_attach(client, bufnr)
    setup_autocommands(client, bufnr)
    --setup_mappings(client)

    require("which-key").register(require("as.mappings").lsp)

    if client.resolved_capabilities.goto_definition then
        vim.bo[bufnr].tagfunc = "v:lua.as.lsp.tagfunc"
    end
end

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

---  NOTE: This is the secret sauce that allows reading requires and variables
--- between different modules in the nvim lua context
--- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
--- if I ever decide to move away from lua dev then use the above
---  NOTE: we return a function here so that the lua dev dependency is not
--- required till the setup function is called.
local function LSP_sumneko_lua()
    local ok, lua_dev = as.safe_require("lua-dev")
    if not ok then
        return {}
    end
    return lua_dev.setup({
        lspconfig = {
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
                    telemetry = { enable = false },
                    completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
                },
            },
        },
    })
end

local function LSP_jsonls()
    return {
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
            },
        },
    }
end

--- LSP server configs are setup dynamically as they need to be generated during
--- startup so things like runtimepath for lua is correctly populated
as.lsp.servers = {
    gopls = true,
    pyright = true,
    jedi_language_server = true,
    yamlls = true,
    --bashls = true,
    --jsonls = LSP_jsonls,
    sumneko_lua = LSP_sumneko_lua,
}

local function get_wanted_lsp()
    local r = {}

    for k, v in pairs(as.lsp.servers) do
        if v then
            table.insert(r, k)
        end
    end

    return r
end

---Logic to (re)start installed language servers for use initialising lsps
---and restarting them on installing new ones
function as.lsp.get_server_config(server)
    --local nvim_lsp_ok, cmp_nvim_lsp = as.safe_require 'cmp_nvim_lsp'
    local conf = as.lsp.servers[server.name]
    local conf_type = type(conf)
    local config = conf_type == "table" and conf or conf_type == "function" and conf() or {}
    config.flags = { debounce_text_changes = 500 }
    config.on_attach = as.lsp.on_attach
    config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
    --if nvim_lsp_ok then
    --  cmp_nvim_lsp.update_capabilities(config.capabilities)
    --end
    return config
end

M.lsp_config = function()
    --local lsp_installer = require("nvim-lsp-installer")
    --lsp_installer.on_server_ready(function(server)
    --    server:setup(as.lsp.get_server_config(server))
    --    vim.cmd([[ do User LspAttachBuffers ]])
    --end)
    M.lsp_installer_init()
end

M.lsp_installer = function()
    vim.defer_fn(function()
        require("packer").loader("nvim-lsp-installer")
    end, 0)
    -- reload the current file so lsp actually starts for it
    vim.defer_fn(function()
        vim.cmd('if &ft == "packer" | echo "" | else | silent! e %')
    end, 0)
end

M.lsp_installer_init = function()
    local options = {
        automatic_installation = false,
        ensure_installed = get_wanted_lsp(),
        ui = {
            server_installed = " ",
            server_pending = " ",
            server_uninstalled = " ﮊ",
        },
        keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            check_server_version = "c",
            update_all_servers = "U",
            check_outdated_servers = "C",
            uninstall_server = "X",
        },
        max_concurrent_installers = 20,
    }

    local lsp_installer = require("nvim-lsp-installer")
    lsp_installer.setup(options)
end

M.null_ls = function()
    local null_ls = require("null-ls")
    -- NOTE: this plugin will break if it's dependencies are not installed
    null_ls.setup({
        debounce = 150,
        on_attach = as.lsp.on_attach,
        sources = {
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.formatting.stylua.with({
                condition = function(_utils)
                    return as.executable("stylua") and _utils.root_has_file("stylua.toml")
                end,
            }),
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
