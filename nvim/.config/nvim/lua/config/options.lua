-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.spelllang = { "en", "pt" }
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.spell = true
vim.g.root_spec = {
  "lsp",
  { ".git", "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts", "lua" },
  "cwd",
}
vim.opt.breakindent = true
vim.opt.path:append({ "**" })
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.wildignore:append({
  "*/.git/*",
  "*/.idea/*",
  "*/target/*",
  "*/build/*",
  "*.class",
  "*.jar",
  "*.war",
  "*log",
  "*.tmp",
  "*/node_modules/*",
  "*/dist/*",
})
