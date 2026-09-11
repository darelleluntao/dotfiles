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
- Herdr pane/session configuration and helper scripts
- OMP plugin manifest and enabled-plugin lockfile (runtime state is excluded)
- Backup-then-symlink installer

## Install

```bash
git clone https://github.com/darelleluntao/dotfiles.git ~/Developer/Personal/dotfiles
cd ~/Developer/Personal/dotfiles
./install.sh            # add --dry-run first to see exactly what it will do
```

`install.sh` backs up any existing target into `~/.dotfiles-backup/<timestamp>/`
and replaces it with a symlink into the repo. It is idempotent: a target that
already points at the repo is left untouched, so running it twice is safe. It
detects the platform and skips anything that does not apply rather than failing.

### macOS

```bash
./install.sh
brew bundle --file Brewfile     # Homebrew packages (macOS only)
```

The Homebrew shell hook in `.zshrc` auto-detects Apple Silicon
(`/opt/homebrew`) vs Intel (`/usr/local`) vs no Homebrew at all.

### Headless Linux server

`install.sh` runs as a non-root user and needs no `sudo`. It links the portable
config (zsh, tmux, vim, Neovim, git, Herdr) and skips the macOS-only pieces:

- Homebrew and the `Brewfile` are not used — install tools with the system
  package manager instead (see below).
- `~/.zprofile` and `~/.p10k.zsh` are linked only when `zsh` is on `PATH`.
- OMP plugin manifests are linked only when `~/.omp` already exists.

```bash
./install.sh
```

Then install the tools the config expects. Debian/Ubuntu example:

```bash
sudo apt install git neovim tmux vim ripgrep fzf bat eza zoxide build-essential
```

#### oh-my-zsh + powerlevel10k (prompt)

`.zshrc` loads oh-my-zsh and the powerlevel10k theme **only if they are already
installed** — a box without them still gets a working zsh, just a plain prompt.
`install.sh` does not bootstrap them (it only symlinks config, no network). To get
the full prompt, run these once as your normal user (no `sudo`, unattended,
idempotent — re-running is a no-op):

```bash
# oh-my-zsh (unattended: no shell change, no auto-launch)
RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# powerlevel10k theme into oh-my-zsh's custom dir
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" \
  || git -C "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" pull
```

The repo's `~/.p10k.zsh` is already symlinked by `install.sh`, so the prompt
picks up the captain's config on the next shell start. A Nerd Font in your
terminal is needed for the glyphs to render.

Minimum for a usable shell + editor: **git** and **Neovim ≥ 0.11** (the LSP
layer uses `vim.lsp.config`/`vim.lsp.enable`; on an older Neovim that layer
degrades to a plain editor with a warning instead of erroring).

Neovim extras that need a toolchain at first launch:

- **C compiler + make** — builds `telescope-fzf-native`; Treesitter parser
  builds also use it (`build-essential` on Debian/Ubuntu).
- **tree-sitter CLI** (optional) — only needed to build parsers not shipped as
  pre-built grammars.

Anything missing degrades gracefully: every Neovim layer is loaded with `pcall`,
plugin setup is guarded with `pcall(require, ...)`, and `glow` markdown preview
is enabled only when `glow` is on `PATH`.

On first `nvim` launch, `lua/plugins.lua` bootstraps lazy.nvim by cloning it into
`stdpath("data")`, then installs the plugin set. If `git` is missing it warns and
skips rather than failing on every startup.

## Refresh repo from current machine

```bash
./update-dotfiles              # shows a diff for every changed file, then asks
./scripts/secret-scan.sh
git diff
```

`update-dotfiles` is **not** a blind copy. It prints a unified diff for each file
that differs (`<` repo, `>` live) and requires an interactive `y` confirmation
before it writes anything. Use `--dry-run` to review without writing, or `--yes`
for non-interactive use once you have read the diffs. This guards against a live
macOS file silently overwriting the repo's portability hardening (Homebrew
detection, `$HOME`-relative paths, existence guards around optional tools).

Only accept changes that are genuine preferences. Commit only after reviewing the
diff and confirming no machine secrets are present.

## Manual post-install steps

- Recreate SSH keys or copy them through a secure password manager. Do not commit them.
- Edit `~/.gitconfig` from `git/.gitconfig.example`.
- Install tmux plugins with `prefix + I` after launching tmux.
- Open Neovim and run `:Lazy sync`, `:Mason`, and `:checkhealth vim.lsp` if needed.
- After installing OMP, run `bun install --cwd ~/.omp/plugins` to install the tracked plugin manifest.
- Herdr helper scripts require the `herdr` CLI, Python 3, and macOS System Events access.
