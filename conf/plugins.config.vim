scriptencoding utf-8

lua << END
-- lualine
require('lualine').setup {
    options = {
        theme = 'wombat',
    }
}

-- bufferline
require("bufferline").setup {
    options = {
        separator_style = "slant"
    }
}
END


" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>