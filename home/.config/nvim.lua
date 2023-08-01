return {
  plugins = {
    {
      "stevearc/aerial.nvim",
      enabled = false,
    },
    {
      "lewis6991/gitsigns.nvim",
      enabled = false,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      enabled = false,
    },
    "simrat39/rust-tools.nvim",
    {
      "williamboman/mason-lspconfig.nvim",
      config = {
        ensure_installed = {
          "lua_ls",
          "omnisharp",
          "dockerls",
          "html",
          "jsonls",
          "tsserver",
          --"pyright",
          "sqlls",
          "svelte",
          "tailwindcss",
          "lemminx",
          "yamlls",
          "powershell_es",
        },
        automatic_installation = true,
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      config = {
        ensure_installed = {
          "lua",
          "fish",
          "html",
          "json",
          "json5",
          "markdown",
          "python",
          "rust",
          "sql",
          "svelte",
          "toml",
          "typescript",
          "yaml",
          "c_sharp",
          "query",
          "css",
          "scss",
        },
        playground = {
          enable = true,
        },
      },
    },
    {
      "nvim-treesitter/playground",
    },
    {
      "jay-babu/mason-null-ls.nvim",
      config = {
        ensure_installed = {
          "csharpier",
          "fixjson",
          "luacheck",
          "eslint",
          "prettierd",
        },
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      config = {
        pickers = {
          find_files = {
            find_command = { "fd", "-H", "--type", "f", "--follow", "--exclude", ".git", "--exclude", "node_modules" },
          },
        }
      }
    },
    {
      "goolord/alpha-nvim",
      config = {
        section = {
          header = {
            val = {
              "███    ██ ██    ██ ██ ███    ███",
              "████   ██ ██    ██ ██ ████  ████",
              "██ ██  ██ ██    ██ ██ ██ ████ ██",
              "██  ██ ██  ██  ██  ██ ██  ██  ██",
              "██   ████   ████   ██ ██      ██",
            },
          },
        },
      },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      config = {
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            never_show = {
              ".git",
              "node_modules",
            }
          }
        }
      }
    },
    {
      "marilari88/twoslash-queries.nvim",
      config = {
        multi_line = true,
      },
    },
    {
      "github/copilot.vim",
      lazy = false,
    },
    {
      "hrsh7th/nvim-cmp",
      config = function(_, opts)
        local cmp = require "cmp"
        opts.mapping = cmp.mapping.preset.insert {
          ---@diagnostic disable-next-line: missing-parameter
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }
        cmp.setup(opts)
      end,
      lazy = false,
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      lazy = false,
    },
    -- {
    --   "Hoffs/omnisharp-extended-lsp.nvim",
    --   lazy = false,
    -- },
  },
  mappings = {
    n = {
      ["<C-p>"] = { function() require("telescope.builtin").find_files() end, desc = "Find files" },
    },
  },
  options = {
    opt = {
      shortmess = vim.opt.shortmess + { I = true },
      listchars = {
        tab = ">·",
        trail = "·",
        extends = "»",
        precedes = "«",
        eol = "⏎",
      },
      clipboard = {
        ["+"] = "unnamedplus",
      },
      list = true,
    },
  },
  lsp = {
    setup_handlers = {
      rust_analyzer = function(_, opts)
        require("rust-tools").setup {
          server = opts,
        }
      end,
    },
    formatting = {
      format_on_save = {
        ignore_filetypes = {
          "ps1",
          "xml",
          "cs",
          "json",
        },
      },
      -- filter = function(client)
      --   if vim.bo.filetype == "javascript" then return client.name == "null-ls" end
      --   if vim.bo.filetype == "typescriptreact" then return client.name == "null-ls" end
      --
      --   return true
      -- end,
      disabled = {
        "tsserver",
      },
    },
    ["powershell_es"] = {
      powershell = {
        analyzeOpenDocumentsOnly = true,
      },
    },
    config = {
      ["rust_analyzer"] = {
        settings = {
          ["rust-analyzer"] = {
            completion = {
              postfix = {
                enable = false,
              },
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      ["omnisharp"] = {
        on_attach = function(client)
          local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
          for i, v in ipairs(tokenModifiers) do
            tokenModifiers[i] = v:gsub(" ", "_")
          end
          local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
          for i, v in ipairs(tokenTypes) do
            tokenTypes[i] = v:gsub(" ", "_")
          end
        end,
        -- handlers = {
        --   ["textDocument/definition"] = require("omnisharp_extended").handler,
        -- },
      },
      tsserver = {
        on_attach = function(client, bufnr) require("twoslash-queries").attach(client, bufnr) end,
      },
    },
  },
  polish = function()
    vim.filetype.add {
      extension = {
        jenkinsfile = "ruby",
      },
    }
    vim.g.loaded_matchparen = 1
    vim.g.copilot_assume_mapped = true
  end,
  header = {},
}
