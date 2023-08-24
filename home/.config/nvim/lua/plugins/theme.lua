return {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require('onedark').setup {
        colors = {
          red = '#61afef'
        }
      }

      require('onedark').load()
    end,
}
