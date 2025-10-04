-- lua/plugins/cmp.lua
-- 描述：配置 nvim-cmp，使用 Tab/S-Tab 选择，Enter 确认。
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-nvim-lsp", -- LSP 补全源
    "hrsh7th/cmp-buffer", -- Buffer 文本补全源
    "hrsh7th/cmp-path", -- 文件路径补全源
    "mfussenegger/nvim-jdtls", -- 确保 jdtls 插件作为依赖
  },
  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()

    return {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- <<<<< 新的快捷键绑定 >>>>>
      mapping = {
        -- Tab: 选择下一个项目
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Shift-Tab: 选择上一个项目
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Enter: 确认当前选择
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        -- Esc 或 C-e: 关闭补全窗口
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Esc>"] = cmp.mapping.close(),

        -- 使用 C-f / C-b 来滚动文档
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      },

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "jdtls" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    }
  end,
}
