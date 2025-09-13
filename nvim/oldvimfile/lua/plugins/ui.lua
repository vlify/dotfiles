-- lua/plugins/ui.lua
return {
    {"folke/tokyonight.nvim", lazy = false,
      priority = 1000, opts = {},},  -- 主题
    {'nvim-lualine/lualine.nvim'},  -- 状态栏
    { 'nvim-tree/nvim-web-devicons' }, -- 更多图标
    { "nvim-tree/nvim-tree.lua" }, -- 文件树
    {'akinsho/bufferline.nvim', version = "*"},--顶部状态栏
}

