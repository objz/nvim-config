local jdtls = require("jdtls")

local home = os.getenv("HOME")
local mason_packages = home .. "/.local/share/nvim/mason/packages"
local jdtls_path = mason_packages .. "/jdtls"
local lombok_path = jdtls_path .. "/lombok.jar"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

local config_os = "linux"

local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

local project_name = vim.fn.fnamemodify(root_dir, ":p:h"):match("([^/]+)$")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

local capabilities = require("blink.cmp").get_lsp_capabilities()

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok_path,
    "-jar", launcher_jar,
    "-configuration", jdtls_path .. "/config_" .. config_os,
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
    },
  },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
    end

    local refresh_gradle_and_restart = function()
      local root_dir = client.config and client.config.root_dir
      if not root_dir then
        vim.notify("JDTLS root dir not available", vim.log.levels.WARN)
        return
      end

      local gradlew = root_dir .. "/gradlew"
      local cmd = nil

      if vim.fn.executable(gradlew) == 1 then
        cmd = { gradlew, "--refresh-dependencies" }
      elseif vim.fn.executable("gradle") == 1 then
        cmd = { "gradle", "--refresh-dependencies" }
      end

      if not cmd then
        vim.notify("Gradle not found in project or PATH", vim.log.levels.WARN)
        return
      end

      vim.notify("Refreshing Gradle dependencies...", vim.log.levels.INFO)

      vim.fn.jobstart(cmd, {
        cwd = root_dir,
        on_exit = function(_, code)
          if code == 0 then
            vim.schedule(function()
              vim.notify("Gradle refresh complete. Restarting JDTLS...", vim.log.levels.INFO)
              pcall(vim.cmd, "JdtUpdateConfig")
              pcall(vim.cmd, "JdtRestart")
            end)
          else
            vim.schedule(function()
              vim.notify("Gradle refresh failed. See :messages for details.", vim.log.levels.ERROR)
            end)
          end
        end,
      })
    end

    map("n", "<leader>cG", refresh_gradle_and_restart, "[Java] Refresh Gradle & Restart JDTLS")

    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
  end,
  init_options = {
    bundles = (function()
      local bundles = {}
      local debug_adapter = vim.fn.glob(mason_packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1, 1)
      if type(debug_adapter) == "table" and #debug_adapter > 0 then
        vim.list_extend(bundles, debug_adapter)
      elseif type(debug_adapter) == "string" and debug_adapter ~= "" then
        table.insert(bundles, debug_adapter)
      end

      local java_test = vim.fn.glob(mason_packages .. "/java-test/extension/server/*.jar", 1, 1)
      if type(java_test) == "table" and #java_test > 0 then
        vim.list_extend(bundles, java_test)
      elseif type(java_test) == "string" and java_test ~= "" then
         table.insert(bundles, java_test)
      end
      
      return bundles
    end)(),
  },
}
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    jdtls.start_or_attach(config)
  end,
})
