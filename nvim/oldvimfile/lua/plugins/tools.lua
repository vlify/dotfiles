-- lua/plugins/tools.lua
return {
    { "numToStr/Comment.nvim", config = true }, -- 代码注释
    { "windwp/nvim-autopairs", config = true }, -- 括号自动补全
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } }, -- 快捷搜索
    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }, -- 调试
    {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"}, --语法高亮
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {"neovim/nvim-lspconfig"},
         -- 自动补全
  {"hrsh7th/nvim-cmp"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"L3MON4D3/LuaSnip"}, -- snippets引擎，不装这个自动补全会出问题
  {"saadparwaiz1/cmp_luasnip"},
  {"rafamadriz/friendly-snippets"},
  {"hrsh7th/cmp-path"}, -- 文件路径
}

