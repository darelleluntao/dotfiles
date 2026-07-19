# Darelle's dotfiles

Portable shell/editor configuration for moving to a new Mac, development laptop, or server.

This repo intentionally tracks reproducible configuration only. It does not track SSH private keys, auth tokens, shell history, editor state, local logs, or generated plugin caches.

## What is included

- Zsh and Powerlevel10k config
- tmux config
- Vim shared config
- Neovim IDE config with lazy.nvim, Neo-tree, LSP, Mason, completion, Treesitter, and Git change signs
- Git ignore defaults and a safe `.gitconfig.example`
- Homebrew `Brewfile`
- Backup-then-symlink installer

## Install on a new machine

```bash
git clone https://github.com/darelleluntao/dotfiles.git ~/Developer/Personal/dotfiles
cd ~/Developer/Personal/dotfiles
./install.sh
```

The installer backs up existing files into `~/.dotfiles-backup/<timestamp>/` before creating symlinks.

## Install Homebrew packages

```bash
brew bundle --file Brewfile
```

## Refresh repo from current machine

```bash
./update-dotfiles
./scripts/secret-scan.sh
git diff
```

Only commit after reviewing the diff and confirming no machine secrets are present.

## Manual post-install steps

- Recreate SSH keys or copy them through a secure password manager. Do not commit them.
- Edit `~/.gitconfig` from `git/.gitconfig.example`.
- Install tmux plugins with `prefix + I` after launching tmux.
- Open Neovim and run `:Lazy sync`, `:Mason`, and `:checkhealth vim.lsp` if needed.
