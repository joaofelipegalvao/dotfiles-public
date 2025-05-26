return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          format = {
            enabled = false,
          },
        },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local mason_path = vim.fn.stdpath("data") .. "/mason/bin/google-java-format"
      opts.formatters_by_ft = {
        java = { "google_java_format" },
      }
      opts.formatters = {
        google_java_format = {
          command = mason_path,
          args = { "-" },
          stdin = true,
        },
      }

-- XML com xmllint
    opts.formatters_by_ft.xml = { "xmllint" }
    opts.formatters.xmllint = {
      command = "xmllint",
      args = { "--format", "-" },
      stdin = true,
    }
    end,
  },
}
