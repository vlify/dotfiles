local capabilities = require("cmp_nvim_lsp").default_capabilities()

local config = {
  name = "jdtls",
  cmd = { "jdtls" },
  -- root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }),
  root_dir = vim.fn.getcwd(),

  capabilities = capabilities,  

  settings = {
    java = {
      completion = {
        importOrder = { "java", "javax", "com", "org" },
        importStarThreshold = 9999,
        guessMethodArguments = true,
      },
      contentProvider = { preferred = "fernflower" },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      signatureHelp = { enabled = true },
    },
  },

  init_options = {
    bundles = {},
  },
}

require("jdtls").start_or_attach(config)

