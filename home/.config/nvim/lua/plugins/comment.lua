return {
  {
    'numToStr/Comment.nvim',
    opts = {
      toggler = {
        line = '<leader>/',
      },
      opleader = {
        line = '<leader>/',
      },
    },
    lazy = false,
    enabled = vim.g.plugins.comment.enabled,
  },
}
