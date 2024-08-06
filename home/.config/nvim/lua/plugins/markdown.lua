return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Recommended

  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH
    "nvim-treesitter/nvim-treesitter",

    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    require("markview").setup({
      modes = { "n", "i" },
      hybrid_modes = { "i", "no", "v", "c", "o" },
    })
  end,
}
