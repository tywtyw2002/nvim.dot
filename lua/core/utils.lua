local M = {}

-- Inject Config for base46 Themes
M.load_config = function ()
    return {
        ui = {
            changed_themes = {}
        }
    }
end


return M