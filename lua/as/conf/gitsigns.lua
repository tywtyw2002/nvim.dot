return function()
    local gitsigns = require("gitsigns")

    gitsigns.setup({
        signs = {
            add = { hl = "DiffAdd", text = "▌" },
            change = { hl = "DiffChange", text = "▌" },
            delete = { hl = "DiffChange", text = "▌" },
            topdelete = { hl = "DiffDelete", text = "▌" },
            changedelete = { hl = "DiffChangeDelete", text = "▌" },
        },
        word_diff = false,
        numhl = false,
        on_attach = function()
            require("which-key").register({
                ["<leader>h"] = {
                    name = "+Gitsigns Hunk",
                    s = { gitsigns.stage_hunk, "Gitsigns: Stage" },
                    u = { gitsigns.undo_stage_hunk, "Gitsigns: Undo Stage" },
                    r = { gitsigns.reset_hunk, "Gitsigns: Reset Hunk" },
                    p = { gitsigns.preview_hunk, "Gitsigns: Preview Current Hunk" },
                    b = { gitsigns.blame_line, "Gitsigns: Blame Current Line"},
                },
                ["<localleader>g"] = {
                    name = "+Gitsigns Git",
                    w = { gitsigns.stage_buffer, "Gitsigns: Stage Entire Buffer" },
                    r = {
                        name = "+Gitsigns Reset",
                        e = { gitsigns.reset_buffer, "Gitsigns: Reset Entire Buffer" },
                    },
                    b = {
                        name = "+Gitsigns Blame",
                        l = { gitsigns.blame_line, "Gitsigns: Blame Current Line" },
                        d = { gitsigns.toggle_word_diff, "Gitsigns: Toggle Word Diff" },
                    },
                },
                ["[h"] = {
                    "&diff ? ']h' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
                    "Gitsigns: Next git hunk",
                    expr = true,
                },
                ["]h"] = {
                    "&diff ? '[h' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
                    "Gitsigns: Previous git hunk",
                    expr = true,
                },
                ["<leader>lm"] = {
                    function()
                        gitsigns.setqflist("all")
                    end,
                    "Gitsigns: List Modified in Quickfix",
                },
            })

            as.onoremap("ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>')
            as.xnoremap("ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>')
            -- Text objects
            as.vnoremap("<leader>hs", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)
            as.vnoremap("<leader>hr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)
        end,
    })
end
