return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function() 
      local telescope = require('telescope')

      telescope.setup {
        pickers = {
          find_files = {
            find_command = { "fd", "-H", "--type", "f", "--follow", "--exclude", ".git", "--exclude", "node_modules" },
          },
        }
      }

      pcall(telescope.load_extension, 'fzf')

      vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = 'Find Files' })

      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
    end
  }
}
