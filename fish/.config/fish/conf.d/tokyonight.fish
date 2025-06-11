# Ativa tema Tokyonight para Fish com estilo personalizado

set style moon
set theme tokyonight_$style

set src ~/.ghq/github.com/folke/tokyonight.nvim/extras/fish_themes/$theme.theme
set dst ~/.config/fish/themes/$theme.theme

# Cria symlink se ainda não existir
if not test -L $dst
    ln -s $src $dst
end

# Ativa o tema no Fish
fish_config theme choose $theme

