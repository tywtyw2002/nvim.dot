return function()
  local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
  parser_configs.norg_meta = {
    install_info = {
      url = 'https://github.com/nvim-neorg/tree-sitter-norg-meta',
      files = { 'src/parser.c' },
      branch = 'main',
    },
  }

  require('nvim-treesitter.configs').setup {
    ensure_installed = 'maintained',
    highlight = {
      enable = true,
      use_languagetree = true
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = '<leader>v', -- maps in normal mode to init the node/scope selection
        node_incremental = '<leader>v', -- increment to the upper named parent
        node_decremental = '<leader>V', -- decrement to the previous node
        scope_incremental = 'grc', -- increment to the upper scope (as defined in locals.scm)
      },
    },
    indent = {
      enable = true,
    },
    textobjects = {
      lookahead = true,
      select = {
        enable = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['aC'] = '@conditional.outer',
          ['iC'] = '@conditional.inner',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['[w'] = '@parameter.inner',
        },
        swap_previous = {
          [']w'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
      },
      lsp_interop = {
        enable = true,
        border = 'rounded',
        peek_definition_code = {
          ['<leader>df'] = '@function.outer',
          ['<leader>dF'] = '@class.outer',
        },
      },
    },
    rainbow = {
      enable = true,
      disable = { 'lua', 'json', 'html' },
      colors = {
        'royalblue3',
        'darkorange3',
        'seagreen3',
        'firebrick',
        'darkorchid3',
      },
    },
    autopairs = { enable = true },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { 'BufWrite', 'CursorHold' },
    },
  }
end
