return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",  -- 确保 parser 最新
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "lua", "vim", "vimdoc", "python", "javascript", "html", "css", "c"
        }, -- 自动安装这些语言的 parser
        sync_install = false,
        auto_install = true, -- 缺 parser 时自动装
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      }
    end,
  },
}

