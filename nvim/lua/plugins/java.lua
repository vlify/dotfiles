-- lua/plugins/java.lua

return {
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      -- jdtls 的安装路径，由 mason 管理
      local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

      -- 获取操作系统的名字
      local os
      if vim.fn.has('mac') == 1 then
        os = 'mac'
      elseif vim.fn.has('unix') == 1 then
        os = 'linux'
      else
        -- 对于 Windows 的简单处理，可能需要调整
        os = 'win'
      end

      -- 指定 jdtls 启动器和配置文件
      -- For mac, this would be `.../jdtls/bin/jdtls`
      -- For linux, this would be `.../jdtls/bin/jdtls`
      -- For windows, this would be `.../jdtls/bin/jdtls.bat`
      local jdtls_bin = jdtls_path .. '/bin/jdtls'
      if os == 'win' then
        jdtls_bin = jdtls_bin .. '.bat'
      end
      
      local config_path = jdtls_path .. '/config_' .. os
      
      -- jdtls 的工作区目录，每个项目一个
      -- 这样可以隔离不同项目的依赖和索引
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

      -- 扩展，用于提供 Spring Boot 等框架的额外支持
      -- 这些扩展会由 nvim-jdtls 自动下载
      local bundles = {
        vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
      }
      -- 添加对 java-test 的支持
      vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/java-test/extension/*.jar', true), '\n'))
      -- 添加对 java-debug-adapter 的支持
      vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/java-debug-adapter/extension/*.jar', true), '\n'))

      local config = {
        cmd = {
          'java',
          '-Declipse.application=org.eclipse.jdt.ls.core.id1.JavaLanguageServer',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xms1g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens', 'java.base/java.util=ALL-UNNAMED',
          '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
          '-jar', table.concat(bundles, ':'),
          '-configuration', config_path,
          -- '-data' 参数是 jdtls 的工作区，非常重要
          '-data', workspace_dir,
        },
        
        -- root_dir 是项目根目录的标识，jdtls 会根据这个来识别项目
        -- 对于 Maven 是 'pom.xml'，对于 Gradle 是 'build.gradle'
        root_dir = require('jdtls.setup').find_root({ 'pom.xml', 'build.gradle', '.git' }),

        -- on_attach 函数在 LSP 客户端成功连接到 jdtls 服务器后执行
        -- 在这里设置快捷键是最佳实践
        on_attach = function(client, bufnr)
          -- 启用代码补全 (需要 nvim-cmp)
          if client.server_capabilities.completionProvider then
            require('cmp').setup.buffer { enabled = true }
          end

          -- 设置快捷键
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { noremap = true, silent = true, buffer = bufnr, desc = 'JDTLS: ' .. desc })
          end

          map('gd', vim.lsp.buf.definition, 'Go to Definition')
          map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
          map('gi', vim.lsp.buf.implementation, 'Go to Implementation')
          map('gr', vim.lsp.buf.references, 'Find References')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
          map('<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format Code')

          -- jdtls 扩展功能
          map('<leader>co', require('jdtls').organize_imports, 'Organize Imports')
          map('<leader>cv', require('jdtls').extract_variable, 'Extract Variable')
          map('<leader>cc', require('jdtls').extract_constant, 'Extract Constant')
          map('<leader>ct', require('jdtls').test_class, 'Test Class')
          map('<leader>cn', require('jdtls').test_nearest_method, 'Test Nearest Method')
        end,
      }

      -- 启动 jdtls
      require('jdtls').start_or_attach(config)
    end,
  },


  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')

      -- 注册 Java 调试适配器
      -- 这个适配器由 nvim-jdtls 提供
      dap.adapters.java = function(callback, config)
        local vm_args_table = {}
        if config.vmArgs then
          vm_args_table = vim.split(config.vmArgs, " ")
        end

        local jdtls = require('jdtls')
        jdtls.dap.resolve_dap_config(
          {
            mainClass = config.mainClass,
            projectName = config.projectName,
            vmArgs = vm_args_table,
            args = config.args,
          },
          function(dap_config)
            callback(dap_config)
          end
        )
      end

      -- 定义 Java 调试的启动配置
      dap.configurations.java = {
        {
          type = 'java',
          request = 'launch',
          name = 'Debug (Launch) - Current File',
          -- jdtls 会自动检测主类
          mainClass = '',
          -- jdtls 会自动检测项目名
          projectName = '',
        },
      }

      -- 调试快捷键 (你可以放在一个统一的 keymap 文件中)
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'DAP: Continue' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'DAP: Step Over' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'DAP: Step Into' })
      vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'DAP: Step Out' })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'DAP: Open REPL' })
    end
  }
}
