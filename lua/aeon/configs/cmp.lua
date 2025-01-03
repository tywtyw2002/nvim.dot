local M = {}

local default = {
    completion = { completeopt = "menu,menuone" },

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
    },
}

local function do_mapping()
    local cmp = require("cmp")
    return {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
                vim.fn.feedkeys(
                    vim.api.nvim_replace_termcodes(
                        "<Plug>luasnip-expand-or-jump",
                        true,
                        true,
                        true
                    ),
                    ""
                )
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                vim.fn.feedkeys(
                    vim.api.nvim_replace_termcodes(
                        "<Plug>luasnip-jump-prev",
                        true,
                        true,
                        true
                    ),
                    ""
                )
            else
                fallback()
            end
        end, { "i", "s" }),
    }
end

M.options = function()
    dofile(vim.g.base46_cache .. "cmp")
    default.mapping = do_mapping()
    return vim.tbl_deep_extend("force", default, require("nvchad.cmp"))
end

M.init = function()
    -- require("which-key").register(require("as.mappings").nvimtree)
end

return M
