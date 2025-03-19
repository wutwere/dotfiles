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
# generate Brewfile
brew bundle dump
# install from Brewfile
brew bundle

# yazi dependencies
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide imagemagick font-symbols-only-nerd-font
ya pack -i # yazi plugins

# latex
sudo tlmgr install latexmk
tlmgr search --global --file <missing-file> # then install to fix compile errors
```
