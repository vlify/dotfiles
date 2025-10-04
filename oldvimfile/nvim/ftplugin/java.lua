-- /Users/ent/.config/nvim/ftplugin/java.lua
--
local root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw", "pom.xml", "build.gradle" })

if root_dir == nil then
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.notify("Java fallback mode(omnifanc only)", vim.log.levels.INFO)
else

  local jdtls = require("jdtls")
  local config = {
    name = "jdtls",
    cmd = { "jdtls" },
    -- root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }),
    root_dir = root_dir,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),

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

  jdtls.start_or_attach(config)
end

