# Migration guide

## First-run checklist

1. Install Homebrew.
2. Clone this repo.
3. Run `brew bundle --file Brewfile`.
4. Run `./install.sh`.
5. Start a new shell.
6. Open tmux and press `prefix + I` to install TPM plugins.
7. Open Neovim and run:

```vim
:Lazy sync
:Mason
:checkhealth vim.lsp
```

## Git identity

The repo includes `git/.gitconfig.example` instead of your live `.gitconfig`.
Copy it to `~/.gitconfig`, then set the correct name/email for the machine.

## Secrets policy

Never commit:

- SSH private keys
- `known_hosts`
- GitHub tokens
- `.zsh_history`
- Claude/Codex/Cursor auth or cache files
- API keys, `.env` files, database URLs, payment provider keys

Run this before every commit:

```bash
./scripts/secret-scan.sh
```
