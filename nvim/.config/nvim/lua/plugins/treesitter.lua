return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "css",
        "gitignore",
        "fish",
        "graphql",
        "http",
        "java",
        "javascript",
        "scss",
        "sql",
        "xml",
        "bash",
        "html",
        "markdown",
      })
    end,
  }
}
