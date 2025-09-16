-- /Users/ent/.config/nvim/ftplugin/java.lua
--
local config = {
  name = "jdtls",
  cmd = {"jdtls"},
  --
  -- `root_dir` must point to the root of your project.
  -- See `:help vim.fs.root`
  root_dir = vim.fs.root(0, {'gradlew', '.git', 'mvnw','pom.xml'}),
  capabilities = require('cmp_nvim_lsp').default_capabilities(),

  settings = {
    java = {
      format ={
        enable = true
      }
    }
  },


  -- This sets the `initializationOptions` sent to the language server
  -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
  -- you'll need to set the `bundles`
  --
  -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },
}
require('jdtls').start_or_attach(config)
