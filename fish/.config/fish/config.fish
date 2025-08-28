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

# ---- PATHs ----
set -x PATH $HOME/.local/bin $HOME/.scripts $PATH

# ---- Mise ----
mise activate fish | source

# ---- Starship ----
starship init fish | source

# ---- Editor ----
command -qv nvim && alias vim nvim
set -gx EDITOR nvim

# ---- Theme FZF ----
set -gx FZF_DEFAULT_OPTS "--highlight-line --info=inline-right --ansi --layout=reverse --border=none --color=bg+:#2d3f76,bg:#1e2030,border:#589ed7,fg:#c8d3f5,gutter:#1e2030,header:#ff966c,hl+:#65bcff,hl:#65bcff,info:#545c7e,marker:#ff007c,pointer:#ff007c,prompt:#65bcff,query:#c8d3f5:regular,scrollbar:#589ed7,separator:#ff966c,spinner:#ff007c"


if not pgrep -f ssh-agent > /dev/null
    eval (ssh-agent -c) > /dev/null
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end
