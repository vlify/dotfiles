return {
  "tpope/vim-dadbod",
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
    "kristijanhusak/vim-dadbod-completion",
  },
  cmd = { "DBUI" },
  config = function()
    vim.g.db_ui_save_location = "~/.config/nvim/dbui"
  end,
}
