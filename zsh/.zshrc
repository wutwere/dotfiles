export PATH=~/.local/bin:$PATH

if (( $+commands[mise] )); then
  eval "$(mise activate zsh --shims)"
fi

export ESCDELAY=0
KEYTIMEOUT=1
export EDITOR=nvim

setopt AUTO_CD
setopt SHARE_HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

alias v=nvim
alias lg=lazygit

ls() {
  if (( $+commands[eza] )); then
    command eza --icons --group-directories-first "$@"
  else
    command ls -F --color=auto "$@"
  fi
}

l() {
  if (( $+commands[eza] )); then
    command eza -al --icons --group-directories-first "$@"
  else
    command ls -F --color=auto -al "$@"
  fi
}

source_first() {
  local file
  for file in "$@"; do
    if [[ -r "$file" ]]; then
      source "$file"
      return 0
    fi
  done
  return 1
}

BREW_PREFIX=""
if (( $+commands[brew] )); then
  BREW_PREFIX="$(brew --prefix)"
fi

source_first \
  "$BREW_PREFIX/opt/fzf/shell/completion.zsh" \
  /usr/share/fzf/completion.zsh

source_first \
  "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh" \
  /usr/share/fzf/key-bindings.zsh

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

source_first \
  "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source_first \
  "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
