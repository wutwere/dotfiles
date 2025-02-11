# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=/Applications/WezTerm.app/Contents/MACOS:$PATH
export PATH=~/.local/bin:$PATH
export PATH=~/.aftman/bin:$PATH
export ESCDELAY=0
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
alias ls="ls -F --color=auto"
alias n="nvim"
alias vim="nvim"
alias b="g++ --std=c++17 -DLOCAL -O2 -include-pch /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/bits/stdc++.h.pch -o a"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
