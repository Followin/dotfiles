return {
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace
          }
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      }
    end
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'folke/neodev.nvim',
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
      { 'simrat39/rust-tools.nvim' },
      {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
      }
    },
    config = function()
      local lspconfig = require('lspconfig')

      require('neodev').setup()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- lua
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false
            },
            telemetry = {
              enable = false
            }
          }
        }
      }

      -- rust
      local rt = require("rust-tools")

      rt.setup({
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<Leader>lb", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>la", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
          capabilities = capabilities,
          settings = {
            ["rust-analyzer"] = {
              procMacro = {
                enable = true
              },
              checkOnSave = {
                command = "clippy"
              },
            }
          }
        },
        tools = {
          hover_actions = {
            auto_focus = true,
          },
          runnables = {
            use_telescope = true,
          },
        },
      })

      -- typescript
      lspconfig.tsserver.setup {
        capabilities = capabilities,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>la', "<Cmd>CodeActionMenu<Cr>", opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        end,
      })

      -- nix
      lspconfig.nixd.setup {
        capabilities = capabilities,
      }

      -- c#
      lspconfig.omnisharp.setup {
        capabilities = capabilities,
        cmd = { 'OmniSharp' },
        enable_import_completion = true,
      }

      -- json
      lspconfig.jsonls.setup {
        capabilities = capabilities,
        cmd = { "vscode-json-languageserver", "--stdio" },
      }

      -- efm
      lspconfig.efm.setup {
        capabilities = capabilities,
        init_options = { documentFormatting = true },
        filetypes = { 'typescript', 'json' },
        settings = {
          rootMarkers = { '.git/' },
          languages = {
            typescript = {
              {
                formatCommand =
                'prettierd ${INPUT} ${--range-start=charStart} ${--range-end=charEnd} ${--tab-width=tabSize}',
                formatStdin = true,
                rootMarkers = {
                  '.prettierrc',
                  '.prettierrc.json',
                  '.prettierrc.toml',
                  '.prettierrc.json',
                  '.prettierrc.yml',
                  '.prettierrc.yaml',
                  '.prettierrc.json5',
                  '.prettierrc.js',
                  '.prettierrc.cjs',
                  '.prettierrc.config.js',
                  '.prettierrc.config.cjs',
                }
              }
            },
            json = {
              {
                formatCommand = 'fixjson',
              }
            },
          }
        }
      }

      -- diagnostics
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

      vim.diagnostic.config({
        update_in_insert = true
      })

      require("funcs.autoformat")();
    end
  },
}
