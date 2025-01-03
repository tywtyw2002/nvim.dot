local M = {}

local ensure_installed = {
    -- lua
    "lua-language-server",
    "stylua",

    -- python
    "python-lsp-server",
    "pyright",

    -- "yaml-lsp-server",
    "gopls",
    "rust-analyzer",
}

local default = {
    automatic_installation = false,
    ensure_installed = ensure_installed,
    PATH = "skip",
    ui = {
        icons = {
            package_installed = " ",
            package_pending = " ",
            package_uninstalled = "󰚌 ",
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
            apply_language_filter = "F",
        },
    },
    max_concurrent_installers = 10,
}

M.options = function()
    dofile(vim.g.base46_cache .. "mason")

    return default
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

return M
