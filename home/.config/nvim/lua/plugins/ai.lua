return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    local supermaven = require("supermaven-nvim")
    supermaven.setup({
      log_level = "off",
    })
    vim.keymap.set("n", "<Leader>is", "<Cmd>SupermavenStop<CR>", { desc = "Stop Supermaven" })
  end,
}
