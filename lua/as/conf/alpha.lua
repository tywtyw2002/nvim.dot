local M = {}


local ascii = {
   "                                                     ",
   "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
   "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
   "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
   "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
   "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
   "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
   "                                                     ",
}

local header = {
   type = "text",
   val = ascii,
   opts = {
      position = "center",
      hl = "AlphaHeader",
   },
}

local footer = {
    type = "text",
    val = "",
    opts = {
        position = "center",
        hl = "Number",
    },
}

local function button(sc, txt, cmd)
   local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

   local opts = {
      position = "center",
      text = txt,
      shortcut = sc,
      cursor = 5,
      width = 36,
      align_shortcut = "right",
      hl = "AlphaButtons",
   }

   --if keybind then
   --   opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
   --end

   return {
      type = "button",
      val = txt,
      on_press = function()
         local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
         vim.api.nvim_feedkeys(key, "normal", false)
      end,
      opts = opts,
   }
end

local buttons = {
   type = "group",
   val = {
      button("SPC n b", "  New File  "),
      button("SPC f f", "  Find File  ", ":Telescope find_files<CR>"),
      button("SPC f o", "  Recents  ", ":Telescope oldfiles<CR>"),
      button("SPC f w", "  Find Word  ", ":Telescope live_grep<CR>"),
      button("SPC b m", "  Bookmarks  ", ":Telescope marks<CR>"),
      --button("SPC e s", "  Load Last Session", ":SessionLoad"),
   },
   opts = {
      spacing = 1,
   },
}

local section = {
   header = header,
   buttons = buttons,
   footer = footer,
}


M.config = function()
   section.footer.val = require("as.utils.mo").today()

   --if vim.api.nvim_win_get_height(0) < 25 then
   --   section.header.val = section.footer.val
   --   section.header.opts.hl = 'Number'
   --   section.footer.val = ""
   --end

   require('alpha').setup({
      layout = {
         { type = "padding", val = 3 },
         section.header,
         { type = "padding", val = 3 },
         section.buttons,
         { type = "padding", val = 2 },
         section.footer,
      },
      opts = {},
   })
end


M.setup = function()
    --require("which-key").register(require("as.mappings").alpha)
    vim.cmd([[
        autocmd FileType alpha setlocal nofoldenable
    ]])
end

return M