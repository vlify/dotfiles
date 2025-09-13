-- lua/core/keymaps.lua
vim.g.mapleader = " "   -- 设置 <leader> 键为空格

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 常用快捷键
map("n", "<leader>w", ":w<CR>", opts)   -- 保存
map("n", "<leader>q", ":q<CR>", opts)   -- 退出
map("n", "<leader>h", ":nohlsearch<CR>", opts) -- 取消高亮

-- 窗口移动
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- 文件树
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Telescope 搜索
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)

-- 视觉模式多行移动
map("v","J",":m '>+1<CR>gv=gv")
map("v","K",":m '<-2<CR>gv=gv")

-- 新增窗口
map("n","<leader>sv","<C-w>v")--水平
map("n","<leader>sh","<C-w>s")--垂直

-- buffer切换
map("n","<S-L>",":bnext<CR>")
map("n","<S-H>",":bprevious<CR>")


