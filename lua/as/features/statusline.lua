local fn = vim.fn
local config = require("core.utils").load_config().ui.statusline
local sep_style = config.separator_style

local default_sep_icons = {
    default = { left = "", right = "" },
    round = { left = "", right = "" },
    block = { left = "█", right = "█" },
    arrow = { left = "", right = "" },
}

local separators = (type(sep_style) == "table" and sep_style)
    or default_sep_icons[sep_style]

local sep_l = separators["left"]
local sep_r = separators["right"]

local hotfixed = false

local M = {}

M.modes = {
    ["n"] = { "NORMAL", "St_NormalMode" },
    ["no"] = { "N-PENDING", "St_NormalMode" },
    --["no"] = { "NORMAL (no)", "St_NormalMode" },
    --["nov"] = { "NORMAL (nov)", "St_NormalMode" },
    --["noV"] = { "NORMAL (noV)", "St_NormalMode" },
    --["noCTRL-V"] = { "NORMAL", "St_NormalMode" },
    --["niI"] = { "NORMAL i", "St_NormalMode" },
    --["niR"] = { "NORMAL r", "St_NormalMode" },
    --["niV"] = { "NORMAL v", "St_NormalMode" },
    ["nt"] = { "NTERMINAL", "St_NTerminalMode" },
    --["ntT"] = { "NTERMINAL (ntT)", "St_NTerminalMode" },

    ["v"] = { "VISUAL", "St_VisualMode" },
    --["vs"] = { "V-CHAR (Ctrl O)", "St_VisualMode" },
    ["V"] = { "V-LINE", "St_VisualMode" },
    ["Vs"] = { "V-LINE", "St_VisualMode" },
    [""] = { "V-BLOCK", "St_VisualMode" },

    ["i"] = { "INSERT", "St_InsertMode" },
    ["ic"] = { "INSERT", "St_InsertMode" },
    --["ic"] = { "INSERT (completion)", "St_InsertMode" },
    --["ix"] = { "INSERT completion", "St_InsertMode" },

    ["t"] = { "TERMINAL", "St_TerminalMode" },

    ["R"] = { "REPLACE", "St_ReplaceMode" },
    --["Rc"] = { "REPLACE (Rc)", "St_ReplaceMode" },
    --["Rx"] = { "REPLACEa (Rx)", "St_ReplaceMode" },
    ["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
    --["Rvc"] = { "V-REPLACE (Rvc)", "St_ReplaceMode" },
    --["Rvx"] = { "V-REPLACE (Rvx)", "St_ReplaceMode" },

    ["s"] = { "SELECT", "St_SelectMode" },
    ["S"] = { "S-LINE", "St_SelectMode" },
    [""] = { "S-BLOCK", "St_SelectMode" },
    ["c"] = { "COMMAND", "St_CommandMode" },
    ["cv"] = { "COMMAND", "St_CommandMode" },
    ["ce"] = { "COMMAND", "St_CommandMode" },
    ["r"] = { "PROMPT", "St_ConfirmMode" },
    ["rm"] = { "MORE", "St_ConfirmMode" },
    ["r?"] = { "CONFIRM", "St_ConfirmMode" },
    ["x"] = { "CONFIRM", "St_ConfirmMode" },
    ["!"] = { "SHELL", "St_TerminalMode" },
}

M.mode = function()
    local m = vim.api.nvim_get_mode().mode
    local mode_empty_sep = "%#St_EmptySep#" .. sep_l
    local mode_sep1 = "%#"
        .. M.modes[m][2]
        .. "Sepl#"
        .. sep_l
        .. "%#"
        .. M.modes[m][2]
        .. "# "
    local current_mode = "%#" .. M.modes[m][2] .. "Sep# " .. M.modes[m][1]

    return mode_empty_sep .. mode_sep1 .. current_mode .. "%#St_EmptySpace# "
end

M.fileInfo = function()
    local icon = " 󰈚 "
    local filename = (fn.expand("%") == "" and "Empty ") or fn.expand("%:t")

    if filename ~= "Empty " then
        local devicons_present, devicons = pcall(require, "nvim-web-devicons")

        if devicons_present then
            local ft_icon = devicons.get_icon(filename)
            icon = (ft_icon ~= nil and " " .. ft_icon .. " ") or ""
        end

        filename = " " .. filename .. " "
    end

    return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. sep_r
end

M.git = function()
    if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
        return ""
    end

    local git_status = vim.b.gitsigns_status_dict

    local branch_name = "  " .. git_status.head

    return "%#St_gitIcons#" .. branch_name .. " "
end

M.gitstatus = function()
    if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
        return ""
    end

    local git_status = vim.b.gitsigns_status_dict

    local added = (git_status.added and git_status.added ~= 0)
            and ("%#St_LspInfo#  " .. git_status.added)
        or ""
    local changed = (git_status.changed and git_status.changed ~= 0)
            and ("%#St_lspWarning#  " .. git_status.changed)
        or ""
    local removed = (git_status.removed and git_status.removed ~= 0)
            and ("%#St_lspError#  " .. git_status.removed)
        or ""

    return "%#St_gitIcons#" .. added .. changed .. removed .. "%*"
end

M.Navic_gps = function()
    local navic = require("nvim-navic")
    if navic.is_available() then
        return " %#St_LspHints#" .. navic.get_location()
    else
        return ""
    end
end

-- LSP STUFF
M.LSP_progress = function()
    if not rawget(vim, "lsp") or vim.lsp.status then
        return ""
    end

    local Lsp = vim.lsp.util.get_progress_messages()[1]

    if vim.o.columns < 120 or not Lsp then
        return ""
    end

    local msg = Lsp.message or ""
    local percentage = Lsp.percentage or 0
    local title = Lsp.title or ""
    local spinners =
        { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    local content = string.format(
        " %%<%s %s %s (%s%%%%) ",
        spinners[frame + 1],
        title,
        msg,
        percentage
    )

    if config.lsprogress_len then
        content = string.sub(content, 1, config.lsprogress_len)
    end

    return ("%#St_LspProgress#" .. content) or ""
end

M.LSP_Diagnostics = function()
    if not rawget(vim, "lsp") then
        return ""
    end

    local errors =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local hints =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    local info =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

    errors = (errors and errors > 0)
            and ("%#St_lspError#" .. " " .. errors .. " ")
        or ""
    warnings = (warnings and warnings > 0)
            and ("%#St_lspWarning#" .. "  " .. warnings .. " ")
        or ""
    hints = (hints and hints > 0)
            and ("%#St_lspHints#" .. "󰛩 " .. hints .. " ")
        or ""
    info = (info and info > 0) and ("%#St_lspInfo#" .. "󰋼 " .. info .. " ")
        or ""

    return errors .. warnings .. hints .. info
end

M.LSP_status = function()
    if rawget(vim, "lsp") then
        for _, client in ipairs(vim.lsp.get_active_clients()) do
            if
                client.attached_buffers[vim.api.nvim_get_current_buf()]
                and client.name ~= "null-ls"
            then
                return "%#St_LspStatus#"
                    .. (
                        (
                            vim.o.columns > 120
                            and "   LSP ~ " .. client.name .. " "
                        ) or "   LSP "
                    )
            end
        end
    end
end

M.cwd = function()
    --local dir_icon = "%#St_cwd_icon#" .. "󰉋 "
    --local dir_name = "%#St_cwd_text#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
    local dir_name = "%#St_gitIcons#"
        .. " 󰉋 "
        .. fn.fnamemodify(fn.getcwd(), ":t")
        .. " "
    return (vim.o.columns > 85 and dir_name) or ""
    --return (vim.o.columns > 85 and ("%#St_cwd_sep#" .. sep_l .. dir_name)) or ""
end

M.cursor_position = function()
    local left_sep_space = "%#St_EmptySepSpace#" .. sep_l
    local left_sep = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#" .. " "

    local current_line = fn.line(".")
    local total_line = fn.line("$")
    local text = math.modf((current_line / total_line) * 100) .. tostring("%%")
    text = string.format("%4s", text)

    text = (current_line == 1 and "Top") or text
    text = (current_line == total_line and "Bot") or text

    return left_sep_space .. left_sep .. "%#St_pos_text#" .. " " .. text .. " "
end

M.hotfix_hl = function()
    local hl = vim.api.nvim_get_hl(0, {})
    local modes = {}
    for _, m in pairs(M.modes) do
        local hl_name = m[2]
        modes[hl_name] = true
    end

    local bg = hl["St_EmptySpace"].bg
    for name, _ in pairs(modes) do
        --hl_conf = hl[name]

        --if hl_conf then
        --  --local bg, fg = hl_conf.bg, hl_conf.fg
        --  hl_conf.fg = hl_conf.bg
        --  hl_conf.bg = empty.bg
        --  vim.api.nvim_set_hl(0, name, hl_conf)
        --end

        hl_sep = hl[name .. "Sep"]
        if hl_sep then
            hl_sep.bg = bg
            vim.api.nvim_set_hl(0, name .. "Sep", hl_sep)
            hl_sep.bg = hl["St_EmptySpace"].fg
            vim.api.nvim_set_hl(0, name .. "Sepl", hl_sep)
        end
    end

    local pos_sep = hl["St_pos_sep"]

    vim.api.nvim_set_hl(
        0,
        "St_EmptySep",
        { bg = hl["St_EmptySpace2"].bg, fg = hl["St_EmptySpace"].fg }
    )
    vim.api.nvim_set_hl(
        0,
        "St_EmptySepSpace",
        { bg = pos_sep.bg, fg = hl["St_EmptySpace"].fg }
    )

    pos_sep.bg = hl["St_EmptySpace"].fg
    vim.api.nvim_set_hl(0, "St_pos_sep", pos_sep)
    --vim.api.nvim_set_hl(0, "St_cwd_icon", {fg=hl['St_EmptySpace2'].fg, bg=hl['St_EmptySpace2'].bg}})
end

M.run = function()
    --local modules = require "nvchad_ui.statusline.default"

    --if config.overriden_modules then
    --modules = vim.tbl_deep_extend("force", modules, config.overriden_modules())
    --end
    if not hotfixed then
        M.hotfix_hl()
        hotfixed = true
    end

    local modules = M

    return table.concat({
        modules.fileInfo(),
        modules.cwd(),
        modules.gitstatus(),
        modules.LSP_Diagnostics(),

        "%=",
        modules.Navic_gps(),
        modules.LSP_progress(),
        "%=",

        modules.LSP_status() or "",
        modules.git(),
        modules.mode(),
        modules.cursor_position(),
    })
end

return M
