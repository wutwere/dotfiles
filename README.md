# my dotfiles

![preview](./demo.gif)

# Setup

Managing dotfiles with stow:

```sh
brew install stow
cd dotfiles # assumed inside ~/
stow vim # example, stow what you need
```

# Packages

```sh
# probably can replace mactex-no-gui with basictex
brew install FelixKratz/formulae/borders clipboard fastfetch fzf gcc gh glow mactex-no-gui neovim node powerlevel10k python ripgrep rust sioyek FelixKratz/formulae/sketchybar koekeishiya/formulae/skhd spicetify-cli stow tree-sitter wget koekeishiya/formulae/yabai yazi zoxide
brew install --cask alt-tab discord firefox middleclick obsidian wezterm

# yazi dependencies
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide imagemagick font-symbols-only-nerd-font
ya pack -i # yazi plugins
```
