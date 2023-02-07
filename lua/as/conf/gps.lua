local present, navic = pcall(require, "nvim-navic")

if not present then
    return
end

local options = {
    depth = 5,
}

return function()
    return navic.setup(options)
end
