# INSTALL

## Order

1. Install the packages listed below with the host package manager.
2. Stow the dotfiles:

```sh
stow --target ~ --restow `ls -d */`
```

3. Bootstrap TPM for tmux.

## Zsh

Install:
- `zsh`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `starship`
- `eza`

## Neovim

Install:
- `neovim`
- `tree-sitter-cli`
- `ripgrep`
- `fd`
- `lazygit`
- `delta`

## Tmux

Install:
- `tmux`
- `fzf`
- `zoxide`

Bootstrap TPM:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source-file ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
```

## Nice To Have

Install if available:
- `yazi`
- `btop`
- `bat`
- `fastfetch`

Yazi plugins:
`ya pkg add Rolv-Apneseth/starship`
