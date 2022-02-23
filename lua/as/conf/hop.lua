return function()
    local hop = require("hop")
    -- remove h,j,k,l from hops list of keys
    hop.setup({
        keys = "etovxqpdygfbzcisuran",
        char2_fallback_key = "<space>"
    })
    as.nnoremap("s", hop.hint_char2)
    --as.nnoremap("/", hop.hint_patterns)
    -- NOTE: override F/f using hop motions
    as.noremap({ "x", "n" }, "F", function()
        hop.hint_char1({
            direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
            current_line_only = true,
            inclusive_jump = false,
        })
    end)
    as.noremap({ "x", "n" }, "f", function()
        hop.hint_char1({
            direction = require("hop.hint").HintDirection.AFTER_CURSOR,
            current_line_only = true,
            inclusive_jump = false,
        })
    end)
    as.onoremap("F", function()
        hop.hint_char1({
            direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
            current_line_only = true,
            inclusive_jump = true,
        })
    end)
    as.onoremap("f", function()
        hop.hint_char1({
            direction = require("hop.hint").HintDirection.AFTER_CURSOR,
            current_line_only = true,
            inclusive_jump = true,
        })
    end)
end
