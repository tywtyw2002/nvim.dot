local M = {}

local default = {
   colors = require("as.colors").get()
}

default = {
   options = {
      offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
      buffer_close_icon = "",
      modified_icon = "",
      close_icon = "",
      show_close_icon = true,
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 20,
      show_tab_indicators = true,
      enforce_regular_tabs = false,
      view = "multiwindow",
      show_buffer_close_icons = true,
      separator_style = "thin",
      always_show_bufferline = true,
      diagnostics = false,
      custom_filter = function(buf_number)
         -- Func to filter out our managed/persistent split terms
         local present_type, type = pcall(function()
            return vim.api.nvim_buf_get_var(buf_number, "term_type")
         end)

         if present_type then
            if type == "vert" then
               return false
            elseif type == "hori" then
               return false
            end
            return true
         end

         return true
      end,
   },

   highlights = {
      background = {
         guifg = default.colors.grey_fg,
         guibg = default.colors.black2,
      },

      -- buffers
      buffer_selected = {
         guifg = default.colors.white,
         guibg = default.colors.black,
         gui = "bold",
      },
      buffer_visible = {
         guifg = default.colors.light_grey,
         guibg = default.colors.black2,
      },

      -- for diagnostics = "nvim_lsp"
      error = {
         guifg = default.colors.light_grey,
         guibg = default.colors.black2,
      },
      error_diagnostic = {
         guifg = default.colors.light_grey,
         guibg = default.colors.black2,
      },

      -- close buttons
      close_button = {
         guifg = default.colors.light_grey,
         guibg = default.colors.black2,
      },
      close_button_visible = {
         guifg = default.colors.light_grey,
         guibg = default.colors.black2,
      },
      close_button_selected = {
         guifg = default.colors.red,
         guibg = default.colors.black,
      },
      fill = {
         guifg = default.colors.grey_fg,
         guibg = default.colors.black2,
      },
      indicator_selected = {
         guifg = default.colors.black,
         guibg = default.colors.black,
      },

      -- modified
      modified = {
         guifg = default.colors.red,
         guibg = default.colors.black2,
      },
      modified_visible = {
         guifg = default.colors.red,
         guibg = default.colors.black2,
      },
      modified_selected = {
         guifg = default.colors.green,
         guibg = default.colors.black,
      },

      -- separators
      separator = {
         guifg = default.colors.black2,
         guibg = default.colors.black2,
      },
      separator_visible = {
         guifg = default.colors.black2,
         guibg = default.colors.black2,
      },
      separator_selected = {
         guifg = default.colors.black2,
         guibg = default.colors.black2,
      },

      -- tabs
      tab = {
         guifg = default.colors.light_grey,
         guibg = default.colors.one_bg3,
      },
      tab_selected = {
         guifg = default.colors.black2,
         guibg = default.colors.nord_blue,
      },
      tab_close = {
         guifg = default.colors.red,
         guibg = default.colors.black,
      },
   },
}

local keybind = {
  --["gD"] = {"<Cmd>BufferLinePickClose<CR>", "bufferline: delete buffer"},
  --["gb"] = {"<Cmd>BufferLinePick<CR>", "bufferline: pick buffer"},
  ["<leader><tab>"] = {"<Cmd>BufferLineCycleNext<CR>", "bufferline: next"},
  ["<S-tab>"] = {"<Cmd>BufferLineCyclePrev<CR>", "bufferline: prev"},
  --["[b"] = {"<Cmd>BufferLineMoveNext<CR>", "bufferline: move next"},
  --["]b"] = {"<Cmd>BufferLineMovePrev<CR>", "bufferline: move prev"},
  --["<leader>1"] = {"<Cmd>BufferLineGoToBuffer 1<CR>", "which_key_ignore"},
  --["<leader>2"] = {"<Cmd>BufferLineGoToBuffer 2<CR>", "which_key_ignore"},
  --["<leader>3"] = {"<Cmd>BufferLineGoToBuffer 3<CR>", "which_key_ignore"},
  --["<leader>4"] = {"<Cmd>BufferLineGoToBuffer 4<CR>", "which_key_ignore"},
  --["<leader>5"] = {"<Cmd>BufferLineGoToBuffer 5<CR>", "which_key_ignore"},
  --["<leader>6"] = {"<Cmd>BufferLineGoToBuffer 6<CR>", "which_key_ignore"},
  --["<leader>7"] = {"<Cmd>BufferLineGoToBuffer 7<CR>", "which_key_ignore"},
  --["<leader>8"] = {"<Cmd>BufferLineGoToBuffer 8<CR>", "which_key_ignore"},
  --["<leader>9"] = {"<Cmd>BufferLineGoToBuffer 9<CR>", "bufferline: goto 9"}
}


M.config = function()
  local bufferline = require 'bufferline'

  bufferline.setup {
    bufferline.setup(default),
  }
end

M.setup = function()
   require("which-key").register({
      ["<leader><tab>"] = {"<Cmd>BufferLineCycleNext<CR>", "bufferline: next"},
      ["<S-tab>"] = {"<Cmd>BufferLineCyclePrev<CR>", "bufferline: prev"}
   })
end

return M
