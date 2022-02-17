local M = {}

local present, telescope = pcall(require, "telescope")

if not present then
   return M
end

local default = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
  },
}

M.config = function()
  telescope.setup(default)

  --local extensions = { "themes", "terms" }
  local extensions = {  }

   pcall(function()
    for _, ext in ipairs(extensions) do
      telescope.load_extension(ext)
    end
  end)
end

--M.config = function()
--  local telescope = require 'telescope'
--  local actions = require 'telescope.actions'
--  local themes = require 'telescope.themes'

--  local H = require 'as.highlights'
--  H.plugin(
--   'telescope',
--   { 'TelescopeMatching', { link = 'Title', force = true } },
--   { 'TelescopeBorder', { link = 'GreyFloatBorder', force = true } },
--   { 'TelescopePromptPrefix', { link = 'Statement', force = true } },
--   { 'TelescopeTitle', { inherit = 'Normal', gui = 'bold' } },
--   {
--    'TelescopeSelectionCaret',
--    {
--      guifg = H.get_hl('Identifier', 'fg'),
--      guibg = H.get_hl('TelescopeSelection', 'bg'),
--    },
--   }
--  )

--  local function get_border(opts)
--   return vim.tbl_deep_extend('force', opts or {}, {
--    borderchars = {
--      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
--      prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
--      results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
--      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
--    },
--   })
--  end

--  ---@param opts table
--  ---@return table
--  local function dropdown(opts)
--   return themes.get_dropdown(get_border(opts))
--  end

--  telescope.setup {
--   defaults = {
--    set_env = { ['TERM'] = vim.env.TERM },
--    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
--    -- BUG: remove prefix as it is currently broken
--    -- seems to relate to prompt buffers although currently it isn't being set to
--    -- a prompt buffer
--    --@see: https://github.com/nvim-telescope/telescope.nvim/issues/1251
--    prompt_prefix = '  ', -- 
--    selection_caret = '» ',
--    mappings = {
--      i = {
--       ['<C-w>'] = actions.send_selected_to_qflist,
--       ['<c-c>'] = function()
--        vim.cmd 'stopinsert!'
--       end,
--       ['<esc>'] = actions.close,
--       ['<c-s>'] = actions.select_horizontal,
--       ['<c-j>'] = actions.cycle_history_next,
--       ['<c-k>'] = actions.cycle_history_prev,
--      },
--      n = {
--       ['<C-w>'] = actions.send_selected_to_qflist,
--      },
--    },
--    file_ignore_patterns = { '%.jpg', '%.jpeg', '%.png', '%.otf', '%.ttf' },
--    path_display = { 'smart', 'absolute', 'truncate' },
--    layout_strategy = 'flex',
--    layout_config = {
--      horizontal = {
--       preview_width = 0.45,
--      },
--      cursor = get_border {
--       layout_config = {
--        cursor = { width = 0.3 },
--       },
--      },
--    },
--    winblend = 3,
--    history = {
--      path = vim.fn.stdpath 'data' .. '/telescope_history.sqlite3',
--    },
--   },
--   extensions = {
--    frecency = {
--      --workspaces = {
--      --  conf = vim.env.DOTFILES,
--      --  project = vim.env.PROJECTS_DIR,
--      --  wiki = vim.g.wiki_path,
--      --},
--    },
--    fzf = {
--      override_generic_sorter = true, -- override the generic sorter
--      override_file_sorter = true, -- override the file sorter
--    },
--   },
--   pickers = {
--    buffers = dropdown {
--      sort_mru = true,
--      sort_lastused = true,
--      show_all_buffers = true,
--      ignore_current_buffer = true,
--      previewer = false,
--      theme = 'dropdown',
--      mappings = {
--       i = { ['<c-x>'] = 'delete_buffer' },
--       n = { ['<c-x>'] = 'delete_buffer' },
--      },
--    },
--    oldfiles = dropdown(),
--    live_grep = {
--      file_ignore_patterns = { '.git/' },
--    },
--    current_buffer_fuzzy_find = dropdown {
--      previewer = false,
--      shorten_path = false,
--    },
--    lsp_code_actions = {
--      theme = 'cursor',
--    },
--    colorscheme = {
--      enable_preview = true,
--    },
--    find_files = {
--      hidden = true,
--    },
--    git_branches = dropdown(),
--    git_bcommits = {
--      layout_config = {
--       horizontal = {
--        preview_width = 0.55,
--       },
--      },
--    },
--    git_commits = {
--      layout_config = {
--       horizontal = {
--        preview_width = 0.55,
--       },
--      },
--    },
--    reloader = dropdown(),
--   },
--  }

--  --- NOTE: this must be required after setting up telescope
--  --- otherwise the result will be cached without the updates
--  --- from the setup call
--  local builtins = require 'telescope.builtin'

--  local function project_files(opts)
--   if not pcall(builtins.git_files, opts) then
--    builtins.find_files(opts)
--   end
--  end

--  local function frecency()
--   telescope.extensions.frecency.frecency(dropdown {
--    -- NOTE: remove default text as it's slow
--    -- default_text = ':CWD:',
--    winblend = 10,
--    border = true,
--    previewer = false,
--    shorten_path = false,
--   })
--  end

--  local function gh_notifications()
--   telescope.extensions.ghn.ghn(dropdown())
--  end

--  local function installed_plugins()
--   require('telescope.builtin').find_files {
--    cwd = vim.fn.stdpath 'data' .. '/site/pack/packer',
--   }
--  end

--  local function tmux_sessions()
--   telescope.extensions.tmux.sessions {}
--  end

--  local function tmux_windows()
--   telescope.extensions.tmux.windows {
--    entry_format = '#S: #T',
--   }
--  end
--end

M.setup = function()
  local builtins = require 'telescope.builtin'
  local telescope = require 'telescope'

  local function project_files(opts)
    if not pcall(builtins.git_files, opts) then
      builtins.find_files(opts)
    end
  end

  local function tmux_sessions()
    telescope.extensions.tmux.sessions {}
  end

  local function tmux_windows()
    telescope.extensions.tmux.windows {
      entry_format = '#S: #T',
    }
  end

  require('which-key').register {
   ['<c-p>'] = { project_files, 'telescope: find files' },
   ['<leader>f'] = {
    name = '+telescope',
    a = { builtins.builtin, 'builtins' },
    b = { builtins.current_buffer_fuzzy_find, 'current buffer fuzzy find' },
    --d = { dotfiles, 'dotfiles' },
    f = { builtins.find_files, 'find files' },
    --n = { gh_notifications, 'notifications' },
    g = {
      name = '+git',
      c = { builtins.git_commits, 'commits' },
      b = { builtins.git_branches, 'branches' },
    },
    m = { builtins.man_pages, 'man pages' },
    --h = { frecency, 'history' },
    o = { builtins.buffers, 'buffers' },
    --p = { installed_plugins, 'plugins' },
    R = { builtins.reloader, 'module reloader' },
    r = { builtins.resume, 'resume last picker' },
    s = { builtins.live_grep, 'grep string' },
    t = {
      name = '+tmux',
      s = { tmux_sessions, 'sessions' },
      w = { tmux_windows, 'windows' },
    },
    ['?'] = { builtins.help_tags, 'help' },
   },
   ['<leader>c'] = {
    d = { builtins.lsp_workspace_diagnostics, 'telescope: workspace diagnostics' },
    s = { builtins.lsp_document_symbols, 'telescope: document symbols' },
    w = { builtins.lsp_dynamic_workspace_symbols, 'telescope: workspace symbols' },
   },
  }
end

M.requires = {
  {
   "nvim-telescope/telescope-fzf-native.nvim",
   run = "make",
   after = "telescope.nvim",
   config = function()
    require("telescope").load_extension "fzf"
   end
  },
  --{
  --  "nvim-telescope/telescope-frecency.nvim",
  --  after = "telescope.nvim",
  --  requires = "tami5/sqlite.lua"
  --},
  {
   "camgraff/telescope-tmux.nvim",
   after = "telescope.nvim",
   config = function()
    require("telescope").load_extension "tmux"
   end
  },
  {
   "nvim-telescope/telescope-smart-history.nvim",
   after = "telescope.nvim",
   config = function()
    require("telescope").load_extension "smart_history"
   end
  }
}

return M
