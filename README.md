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
# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# generate Brewfile
brew bundle dump
# install from Brewfile (untested)
brew bundle

# set fish as default shell
./setfish.sh

# yazi plugins
ya pack -i

# latex
sudo tlmgr install latexmk
tlmgr search --global --file <missing-file> # then install to fix compile errors
```
