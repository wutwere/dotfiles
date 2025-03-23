if status is-interactive
end

# PATH
fish_add_path ~/.aftman/bin

switch (uname)
    case "Darwin" # Code for macOS
        eval "$(/opt/homebrew/bin/brew shellenv)"
    case "Linux" # Code for Linux
    case "*" # Code for other OSs
end

# Abbreviations
abbr -ag cd "z"
abbr -ag lg "lazygit"
abbr -ag n "nvim"
abbr -ag v "nvim"

# nvim
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx EDITOR nvim
set -gx ESCDELAY 0

# yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function cht -a query
    if test -z "$query"
        curl -s cht.sh/$(cat ~/.cht_sh | fzf --bind=enter:replace-query+print-query) | less -Rc
    else
        curl -s cht.sh/$query | less -Rc
    end
end

function cinit
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
        eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
    else
        if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
            . /opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish
        else
            set -x PATH "/opt/homebrew/Caskroom/miniconda/base/bin" $PATH
        end
    end
    # <<< conda initialize <<<
end

# zoxide
zoxide init fish | source

function fish_greeting
    if command -q nerdfetch
        nerdfetch
    end
    # new line
    echo
end

