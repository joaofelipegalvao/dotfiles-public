return {

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false
    end,
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
  },

{
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[
╭─ System Monitor - Java Developer Environment ─────────╮
│                                                       │
│ Status: ● ONLINE     Uptime: 365 days, 12:30:45       │
│                                                       │
│ ┌─ Performance Metrics ─────────────────────────────┐ │
│ │                                                   │ │
│ │ ☕ Caffeine Level    ████████████████████▒ 98%    │ │
│ │ 💻 Coding Efficiency ███████████████████▒▒ 92%    │ │
│ │ 🧠 Problem Solving   ██████████████████▒▒▒ 89%    │ │
│ │ 🚀 Innovation Rate   ████████████████▒▒▒▒▒ 85%    │ │
│ │                                                   │ │
│ │      ██╗ █████╗ ██╗   ██╗ █████╗                  │ │
│ │      ██║██╔══██╗██║   ██║██╔══██╗                 │ │
│ │      ██║███████║██║   ██║███████║                 │ │
│ │ ██   ██║██╔══██║╚██╗ ██╔╝██╔══██║                 │ │
│ │ ╚█████╔╝██║  ██║ ╚████╔╝ ██║  ██║                 │ │
│ │  ╚════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝                 │ │
│ └───────────────────────────────────────────────────┘ │
│                                                       │
│ Last Deploy: SUCCESS ✅ | Next Sprint: Planning 📋    │
╰───────────────────────────────────────────────────────╯
        ]],
      },
    },
  },
},

  {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    -- Custom functions for Java project detection
    local function maven_project()
      local pom_file = vim.fn.findfile("pom.xml", ".;")
      if pom_file ~= "" then
        return " Maven"
      end
      return ""
    end

    local function gradle_project()
      local build_gradle = vim.fn.findfile("build.gradle", ".;")
      local build_gradle_kts = vim.fn.findfile("build.gradle.kts", ".;")
      if build_gradle ~= "" or build_gradle_kts ~= "" then
        return " Gradle"
      end
      return ""
    end

    local function spring_boot_indicator()
      local pom_file = vim.fn.findfile("pom.xml", ".;")
      if pom_file ~= "" then
        local content = vim.fn.readfile(pom_file)
        for _, line in ipairs(content) do
          if line:match("spring%-boot") then
            return " Spring"
          end
        end
      end
      return ""
    end

    opts.sections.lualine_a = {
      {
        "mode",
        fmt = function(str)
          local mode_map = {
            ["NORMAL"] = " NORMAL",
            ["INSERT"] = " INSERT",
            ["VISUAL"] = " VISUAL",
            ["V-LINE"] = " V-LINE",
            ["COMMAND"] = " COMMAND",
            ["TERMINAL"] = " TERM",
          }
          return mode_map[str] or str
        end,
      },
    }

    -- Adicionar os indicadores Java na seção lualine_x
    if not opts.sections.lualine_x then
      opts.sections.lualine_x = {}
    end

    -- Inserir os indicadores Java no início da seção lualine_x
    table.insert(opts.sections.lualine_x, 1, {
      maven_project,
      cond = function() return maven_project() ~= "" end,
      color = { fg = "#C71A36" }
    })
    
    table.insert(opts.sections.lualine_x, 2, {
      gradle_project,
      cond = function() return gradle_project() ~= "" end,
      color = { fg = "#02303A" }
    })
    
    table.insert(opts.sections.lualine_x, 3, {
      spring_boot_indicator,
      cond = function() return spring_boot_indicator() ~= "" end,
      color = { fg = "#6DB33F" }
    })

    -- Configurar section_z
    opts.sections.lualine_z = {
      function()
        return " "
      end,
    }
    
    return opts
  end,
},
}
