# my dotfiles

![image](https://github.com/user-attachments/assets/b4cd7b8f-918c-436d-b948-751cb635fbc8)

## Install Sketchybar

For those who just want my sketchybar config:

1. Copy `sketchybar/.config/sketchybar` into your `~/.config/sketchybar` directory.
2. Run `~/.config/sketchybar/helpers/install.sh`
3. Run `brew services restart sketchybar` to restart your sketchybar if it does not update.

Note: My sketchybar config is made to work with [Yabai](https://github.com/koekeishiya/yabai).

## Personal Setup

```sh
# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

cd dotfiles # assumed inside ~/

# to install packages (untested)
brew bundle

stow nvim # example, stow what you need

# set fish as default shell
./setfish.sh

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

### I use Arch btw

```sh
# to export packages
yay -Qqe > arch.txt
# to install packages
yay -S $(cat arch.txt)
```
