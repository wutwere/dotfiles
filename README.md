# my dotfiles

![image](https://github.com/user-attachments/assets/f2bd657b-8e6a-4c62-8715-b9560ae89f99)

# MacOS Setup

Managing dotfiles with stow:

```sh
# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

cd dotfiles # assumed inside ~/

# to install packages (untested)
brew bundle

stow nvim # example, stow what you need

# set fish as default shell
./setfish.sh
```

# Packages

```sh
# to export packages
brew bundle dump

# install fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher update # to install plugins

# install tmux package manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# then `ctrl+space shift+i` inside tmux to reload

# yazi plugins
ya pack -i

# latex
sudo tlmgr install latexmk
tlmgr search --global --file <missing-file> # then install to fix compile errors
```

# I use Arch btw

```sh
# to export packages
yay -Qqe > arch.txt
# to install packages
yay -S $(cat arch.txt)
```
