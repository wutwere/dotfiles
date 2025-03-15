# my dotfiles

![image](https://github.com/user-attachments/assets/f2bd657b-8e6a-4c62-8715-b9560ae89f99)

# Setup

Managing dotfiles with stow:

```sh
brew install stow
cd dotfiles # assumed inside ~/
stow vim # example, stow what you need
```

# Packages

```sh
brew install FelixKratz/formulae/borders clipboard fastfetch fzf gcc gh glow basictex lazygit neovim node powerlevel10k python ripgrep rust sioyek FelixKratz/formulae/sketchybar koekeishiya/formulae/skhd spicetify-cli stow tree-sitter wget koekeishiya/formulae/yabai yazi zoxide tmux
brew install --cask alt-tab discord firefox middleclick obsidian ghostty pika

# yazi dependencies
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide imagemagick font-symbols-only-nerd-font
ya pack -i # yazi plugins

# latex
sudo tlmgr install latexmk
tlmgr search --global --file <missing-file> # then install to fix compile errors
```
