local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",

    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


local plugins = {
  "folke/tokyonight.nvim", -- 主题
  "nvim-lualine/lualine.nvim",  -- 状态栏
  "nvim-tree/nvim-tree.lua",  -- 文档树
  "nvim-tree/nvim-web-devicons", -- 文档树图标

  "christoomey/vim-tmux-navigator", -- 用ctl-hjkl来定位窗口
  "nvim-treesitter/nvim-treesitter", -- 语法高亮

  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig"
  },

      -- 自动补全
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip", -- snippets引擎
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "hrsh7th/cmp-path", -- 文件路径

  "numToStr/Comment.nvim", -- 注释
  "windwp/nvim-autopairs", -- 自动补全括号

  "akinsho/bufferline.nvim", -- buffer
  "lewis6991/gitsigns.nvim", -- git提示
  'mfussenegger/nvim-dap', -- nvim调试
  'mfussenegger/nvim-jdtls', -- java调试配置
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
  }, -- 调试ui界面

  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8', -- 文件检索
    dependencies = { {'nvim-lua/plenary.nvim'} } -- requires要改为dependencies
  },

  -- {
  --   "folke/which-key.nvim", -- 快捷键查询
  --   dependencies = {{ 'nvim-mini/mini.nvim', version = false },}
  -- }
  {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
    dependencies = {{ 'nvim-mini/mini.nvim', version = false },}

}
}
local opts = {} -- 注意要定义这个变量

require("lazy").setup(plugins, opts)
