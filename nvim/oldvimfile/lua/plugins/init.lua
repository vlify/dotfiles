-- lua/plugins/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "plugins.ui" },
        { import = "plugins.git" },
        { import = "plugins.tools" },
    },
    install = { colorscheme = { "tokyonight" } },
    checker = { enabled = true },
})
require("nvim-tree").setup()
require("dapui").setup()
require('lualine').setup()
require("bufferline").setup{}
require("gitsigns").setup()
require("lsp")
require("cmp").setup()


