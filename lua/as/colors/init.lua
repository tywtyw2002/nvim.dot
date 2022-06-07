local M = {}

-- if theme given, load given theme if given, otherwise nvchad_theme
M.init = function(theme)
   if not theme then
      --theme = require("as.utils.core").load_config().ui.theme
      theme = vim.g.nvchad_theme
   end

   -- set the global theme, used at various places like theme switcher, highlights
   --vim.g.nvchad_theme = theme

   local present, base16 = pcall(require, "base46")

   if present then
      -- first load the base16 theme
      --base16(base16.themes(theme), true)
      base16.load_theme()

      -- unload to force reload
      --package.loaded["as.colors.highlights" or false] = nil
      -- then load the highlights
      --require "as.colors.highlights"
   end
end

-- returns a table of colors for given or current theme
M.get = function(theme)
   if not theme then
      theme = vim.g.nvchad_theme
   end

   local present, hl_themes = pcall(require, "hl_themes." .. theme)

   if not present then
      hl_themes = {}
   end

   return hl_themes
end

return M
