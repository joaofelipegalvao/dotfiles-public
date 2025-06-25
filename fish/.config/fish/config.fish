set fish_greeting ""


set -gx COLORTERM truecolor
set -gx TERM xterm-256color

# ---- Yazi setup ----
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# ----  Aliases ----
alias ls='eza --icons'
alias la='eza -A --icons'
alias ll='eza -l --icons'
alias lla='eza -lA --icons'
alias g='git'
alias lzd="lazydocker"
alias lzg="lazygit"

command -qv nvim && alias vim nvim

set -gx EDITOR nvim

# ---- Theme FZF ----
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#2d3f76 \
  --color=bg:#1e2030 \
  --color=border:#589ed7 \
  --color=fg:#c8d3f5 \
  --color=gutter:#1e2030 \
  --color=header:#ff966c \
  --color=hl+:#65bcff \
  --color=hl:#65bcff \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#65bcff \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#589ed7 \
  --color=separator:#ff966c \
  --color=spinner:#ff007c \
"

# ---- Starship ----
starship init fish | source

set -x PATH $HOME/.local/bin $HOME/.cargo/bin $PATH

# ---- Mise ----
/usr/bin/mise activate fish | source
set -gx PATH $HOME/.scripts $PATH
