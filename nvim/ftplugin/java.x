-- /Users/ent/.config/nvim/ftplugin/java.lua
-- 描述：在 jdtls 加载后，安全地设置 Java 专属快捷键。

local jdtls_ft_group = vim.api.nvim_create_augroup("JdtlsFtpluginKeys", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = jdtls_ft_group,
  buffer = 0,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.client_id)
    if client and client.name == "jdtls" then
      local jdtls = require("jdtls")

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
      end

      -- 在这里定义你所有 Java 专属的快捷键
      map("n", "<leader>co", jdtls.organize_imports, "Organize Imports")
      map("n", "<leader>cv", jdtls.extract_variable, "Extract Variable")
      -- ... 其他快捷键 ...
    end
  end,
})
