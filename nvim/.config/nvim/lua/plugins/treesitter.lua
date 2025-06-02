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
        "json",
        "jq",
        "yaml",
        "query",
        "dockerfile",
        "java",
        "javascript",
        "scss",
        "sql",
        "xml",
        "bash",
        "html",
        "markdown",
        "vimdoc"
      })
    end,
  }
}
