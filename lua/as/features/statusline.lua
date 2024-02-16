local fn = vim.fn
local config = require("core.utils").load_config().ui.statusline
local sep_style = config.separator_style

local default_sep_icons = {
    default = { left = "", right = "" },
    round = { left = "", right = "" },
    block = { left = "█", right = "█" },
    arrow = { left = "", right = "" },
}

local c = {
    icons = {
        enabled = "",
        sleep = "",
        disabled = "",
        warning = "",
        unknown = "",
    },
    hl = {
        enabled = "St_LspInfo",
        --sleep = "#AEB7D0",
        disabled = "St_EmptySpace",
        warning = "St_lspWarning",
        --unknown = "#FF5555",
    },
}

function c:setup_hl()
    local hl = vim.api.nvim_get_hl(0, {})
    for name, color in pairs(self.hl) do
        vim.api.nvim_set_hl(
            0,
            "St_copilot_" .. name,
            { fg = hl["St_EmptySpace2"].fg, bg = hl[color].fg }
        )
        vim.api.nvim_set_hl(
            0,
            "St_copilot_" .. name .. "Sep",
            { bg = hl["St_EmptySpace2"].fg, fg = hl[color].fg }
        )
    end
end

function c:get_api()
    if not self.api then
        local present, api = pcall(require, "copilot.api")
        if not present then
            return nil
        end

        self.api = api
    end

    return self.api
end

function c:get_client()
    if not self.client then
        local present, client = pcall(require, "copilot.client")
        if not present then
            return nil
        end

        self.client = client
    end

    return self.client
end

function c:attatched()
    local client = self:get_client()
    return client and client.buf_is_attached(vim.api.nvim_get_current_buf())
end

local separators = (type(sep_style) == "table" and sep_style)
    or default_sep_icons[sep_style]

local sep_l = separators["left"]
local sep_r = separators["right"]

local hotfixed = false

local function gen_right_block(icon, text, sep_hl, icon_hl, text_hl)
    local s = sep_hl .. sep_l .. icon_hl .. icon .. " "
    if text then
        s = s .. text_hl .. " " .. text
    end
    return s
end

local function get_right_fix()
    return "%#St_EmptySep#" .. sep_l
end

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
    local icon_hl = "%#" .. M.modes[m][2] .. "#"
    local text_hl = "%#" .. M.modes[m][2] .. "Text#"
    local sep_hl = "%#" .. M.modes[m][2] .. "Sep#"
    return gen_right_block(
        "",
        M.modes[m][1] .. " ",
        sep_hl,
        icon_hl,
        text_hl
    )
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
    if not rawget(vim, "lsp") then
        return ""
    end

    local lsp_clients = vim.lsp.get_active_clients()

    -- local block = "%#St_EmptySep#" .. sep_l
    local icon = ""
    local client_name = nil
    for _, client in ipairs(lsp_clients) do
        if
            client.attached_buffers[vim.api.nvim_get_current_buf()]
            and client.name ~= "null-ls"
            and client.name ~= "copilot"
        then
            if vim.o.columns > 100 then
                client_name = client.name .. " "
            else
                client_name = "LSP "
                icon = ""
            end
            break
        end
    end

    local copilot_status = M.copilot()

    -- no lsp attatch
    if not copilot_status and client_name == nil then
        return ""
    end

    local text_hl = "%#St_LspStatus#"
    local icon_hl = "%#St_LspStatusIcon#"
    local sep_hl = "%#St_LspStatusSep#"

    if copilot_status then
        if copilot_status == "progress" then
            copilot_status = 'enabled'

            local spinners =
        { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
            local ms = vim.loop.hrtime() / 1000000
            local frame = math.floor(ms / 120) % #spinners
            client_name = spinners[frame + 1] .. "  "
            text_hl = "%#St_LspStatusSpin#"
        end
        icon_hl = "%#St_copilot_" .. copilot_status .. "#"
        sep_hl = "%#St_copilot_" .. copilot_status .. "Sep#"
        icon = c.icons[copilot_status]
    end

    return gen_right_block(icon, client_name or "", sep_hl, icon_hl, text_hl)
end

M.cwd = function()
    local dir_name = "%#St_gitIcons#"
        .. " 󰉋 "
        .. fn.fnamemodify(fn.getcwd(), ":t")
        .. " "
    return (vim.o.columns > 85 and dir_name) or ""
end

M.cursor_position = function()
    local current_line = fn.line(".")
    local total_line = fn.line("$")
    local text = math.modf((current_line / total_line) * 100) .. tostring("%%")
    text = string.format("%4s", text)

    text = (current_line == 1 and "Top") or text
    text = (current_line == total_line and "Bot") or text

    return gen_right_block(
        "",
        text,
        "%#St_pos_sep#",
        "%#St_pos_icon#",
        "%#St_pos_text#"
    )
end

M.reset_hl = function()
    hotfixed = false
end

M.hotfix_hl = function()
    local hl = vim.api.nvim_get_hl(0, {})

    -- reverse the bg & fg for ST_MODE
    local modes = {}
    for _, m in pairs(M.modes) do
        local hl_name = m[2]
        modes[hl_name] = true
    end

    --bg should be colors.lightbg
    local background = hl["St_EmptySpace"].bg
    for name, _ in pairs(modes) do
        local hl_sep = hl[name .. "Sep"]
        if hl_sep then
            hl_sep.bg = background
            vim.api.nvim_set_hl(0, name .. "Sep", hl_sep)
            vim.api.nvim_set_hl(0, name .. "Text", hl_sep)
        end
    end

    local pos_sep = hl["St_pos_sep"]

    -- sep fix for last item
    vim.api.nvim_set_hl(
        0,
        "St_EmptySep",
        { bg = hl["St_EmptySpace2"].bg, fg = background }
    )
    pos_sep.bg = background
    vim.api.nvim_set_hl(0, "St_pos_sep", pos_sep)

    -- fix St_LspStatus
    local lsp_status = hl["St_LspStatus"]
    lsp_status.bg = background
    lsp_status.fg = hl["St_LspHints"].fg
    vim.api.nvim_set_hl(0, "St_LspStatusSep", lsp_status)
    lsp_status.bg = hl["St_LspHints"].fg
    lsp_status.fg = hl["St_EmptySpace2"].fg
    vim.api.nvim_set_hl(0, "St_LspStatusIcon", lsp_status)
    lsp_status.fg = hl["St_gitIcons"].fg
    lsp_status.bg = background
    vim.api.nvim_set_hl(0, "St_LspStatus", lsp_status)
    lsp_status.fg = hl["St_lspWarning"].fg
    lsp_status.bg = background
    vim.api.nvim_set_hl(0, "St_LspStatusSpin", lsp_status)
end

M.copilot = function()
    local client = c:get_client()
    local api = c:get_api()
    if not client or not api then
        return nil
    end

    --check copilot enabled and attatched
    -- and not client.is_current_buffer_attached()
    if client.is_disabled() or not c:attatched() then
        return nil
    end

    local status = api.status.data.status
    if status == "Warning" then
        -- return "%#St_copilot_warning# " .. c.icons.warning
        return "warning"
    end

    ---- InProgress
    if status == "InProgress" then
       return "progress"
    end

    return "enabled"
end

M.run = function()
    if not hotfixed then
        M.hotfix_hl()
        c:setup_hl()
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

        modules.git(),
        get_right_fix(),
        modules.LSP_status(),
        modules.mode(),
        modules.cursor_position(),
    })
end

return M
