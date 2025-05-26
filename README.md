![terminal.png](https://i.postimg.cc/ryj5PP5R/terminal.png)
![ui.png](https://i.postimg.cc/nzchj0rN/ui.png)

## Dotfiles

Este repositório contém meus arquivos de configuração pessoais (dotfiles) para diversas ferramentas e aplicativos no Arch Linux. Ele foi projetado para facilitar a gestão e sincronização do meu ambiente de desenvolvimento.

**Aviso:** Não use minhas configurações cegamente, a menos que você saiba o que isso implica. Use por sua própria conta e risco!

## Conteúdo

- vim (Neovim) config
- tmux config
- lazygit config
- yazi
- starship
- Terminal Ghostty
- Mise

## Neovim setup

### Requisitos

- Neovim >= 0.9.0 (precisa ser compilado com LuaJIT)
- Git >= 2.19.0 (para suporte a clones parciais)
- **[LazyVim](https://www.lazyvim.org/)**
- **[Nerd Font](https://www.nerdfonts.com/)** (v3.0 ou superior) (opcional, mas necessário para exibir alguns ícones)
- **[Lazygit](https://github.com/jesseduffield/lazygit)** (opcional)
- um compilador **C** para <code>nvim-treesitter</code>. Veja **[aqui](https://github.com/nvim-treesitter/nvim-treesitter#requirements)**
- um terminal que suporte cores verdadeiras e <i>undercurl</i>:
  - **[kitty](https://github.com/kovidgoyal/kitty)** (Linux & Macos)
  - **[wezterm](https://github.com/wezterm/wezterm)** (Linux, Macos & Windows)
  - **[alacritty](https://github.com/alacritty/alacritty)** (Linux, Macos & Windows)
  - **[iterm2](https://iterm2.com/)** (Macos)
  - **[Ghostty](https://github.com/ghostty/ghostty)** - (Linux & Macos)
- **[Tokyonight Neovim](https://github.com/folke/tokyonight.nvim)**

## Yazi (Gerenciador de arquivos)

- **[Yazi](https://yazi-rs.github.io/)** - Gerenciador de arquivos rápido e altamente configurável para o terminal, inspirado no Ranger.

## Tmux (Gerenciador de terminal multiplexado)

- **[Tmux](https://github.com/tmux/tmux)** - O tmux é um multiplexador de terminal que permite dividir o terminal em várias sessões, tornando o gerenciamento do terminal mais eficiente e flexível.

## Mise (Gerenciador de configurações)

- **[Mise](https://mise.jdx.dev/)** - Gerenciador de configurações para facilitar o gerenciamento de arquivos de configuração. O Mise permite organizar, sincronizar e versionar suas configurações de maneira mais prática.

## Configuração do Shell (macOS & Linux)

- **[Fish shell](https://fishshell.com/)**
- **[Starship](https://github.com/starship/starship)** - Prompt de linha de comando altamente personalizável
- **[Fisher](https://github.com/jorgebucaran/fisher)** - Gerenciador de plugins
- **[Nerd fonts](https://github.com/ryanoasis/nerd-fonts)** - Fontes modificadas para uso no desenvolvimento. Eu uso **[PlemolJP](https://github.com/yuru7/PlemolJP)** e BlexMono.
- **[z for fish](https://github.com/jethrokuan/z)** Navegação entre diretórios.
- **[Eza](https://github.com/eza-community/eza)** - Substituto do <code>ls</code>
- **[ghq](https://github.com/x-motemen/ghq)** - Organizador de repositórios Git locais
- **[fzf](https://github.com/PatrickF1/fzf.fish)** - Localizador fuzzy
