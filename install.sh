#!/usr/bin/env bash
set -euo pipefail

# Backup-then-symlink installer.
#
# Works on macOS and on a headless Linux server run as a non-root user.
# Anything that does not apply to the current platform is skipped, not failed:
#   - Homebrew and the Brewfile are macOS-only (installed separately, see README).
#   - ~/.zprofile and ~/.p10k.zsh are only linked when zsh is available.
#   - OMP plugin manifests are only linked when ~/.omp is actually in use.
#
# Flags:
#   --dry-run   Print what would change without touching the filesystem.
#   -h, --help  Show this help.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run]

Backs up any existing target files into ~/.dotfiles-backup/<timestamp>/ and
replaces them with symlinks into this repo. Idempotent: a target already
pointing at the repo is left untouched. Works on macOS and headless Linux;
platform-specific pieces are skipped rather than failed.

  --dry-run   Print what would change without touching the filesystem.
  -h, --help  Show this help.
EOF
}

DRY_RUN=0
for arg in "$@"; do
  case "${arg}" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *)
      printf 'unknown argument: %s\n\n' "${arg}" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$(uname -s)" in
  Darwin) IS_MACOS=1 ;;
  *)      IS_MACOS=0 ;;
esac

run() {
  # Execute a mutating command, or just describe it under --dry-run.
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi
  "$@"
}

link_file() {
  local source_path="$1"
  local target_path="$2"

  if [[ ! -e "${source_path}" ]]; then
    printf 'skipped (missing in repo): %s\n' "${source_path}"
    return
  fi

  run mkdir -p "$(dirname "${target_path}")"

  if [[ -e "${target_path}" || -L "${target_path}" ]]; then
    if [[ "$(readlink "${target_path}" 2>/dev/null || true)" == "${source_path}" ]]; then
      printf 'already linked: %s\n' "${target_path}"
      return
    fi

    run mkdir -p "${BACKUP_DIR}$(dirname "${target_path}")"
    run mv "${target_path}" "${BACKUP_DIR}${target_path}"
    printf 'backed up: %s -> %s\n' "${target_path}" "${BACKUP_DIR}${target_path}"
  fi

  run ln -s "${source_path}" "${target_path}"
  printf 'linked: %s -> %s\n' "${target_path}" "${source_path}"
}

# ── Portable config: linked on every platform ──────────────────────────
link_file "${ROOT_DIR}/zsh/.zshrc"                     "${HOME}/.zshrc"
link_file "${ROOT_DIR}/tmux/.tmux.conf"                "${HOME}/.tmux.conf"
link_file "${ROOT_DIR}/vim/.vimrc"                     "${HOME}/.vimrc"
link_file "${ROOT_DIR}/vim/.vim/shared.vim"            "${HOME}/.vim/shared.vim"
link_file "${ROOT_DIR}/nvim/init.vim"                  "${HOME}/.config/nvim/init.vim"
link_file "${ROOT_DIR}/nvim/lua/plugins.lua"           "${HOME}/.config/nvim/lua/plugins.lua"
link_file "${ROOT_DIR}/nvim/lua/ide.lua"               "${HOME}/.config/nvim/lua/ide.lua"
link_file "${ROOT_DIR}/nvim/lua/lsp.lua"               "${HOME}/.config/nvim/lua/lsp.lua"
link_file "${ROOT_DIR}/herdr/config.toml"              "${HOME}/.config/herdr/config.toml"
link_file "${ROOT_DIR}/herdr/scripts/label-panes.sh"   "${HOME}/.config/herdr/scripts/label-panes.sh"
link_file "${ROOT_DIR}/herdr/scripts/send-all-panes.sh" "${HOME}/.config/herdr/scripts/send-all-panes.sh"
link_file "${ROOT_DIR}/git/.gitignore_global"          "${HOME}/.gitignore_global"

# ── zsh login-shell extras: only useful when zsh is present ────────────
if [[ "${IS_MACOS}" -eq 1 ]] || command -v zsh >/dev/null 2>&1; then
  link_file "${ROOT_DIR}/zsh/.zprofile"  "${HOME}/.zprofile"
  link_file "${ROOT_DIR}/zsh/.p10k.zsh"  "${HOME}/.p10k.zsh"
else
  printf 'skipped (zsh not installed): %s, %s\n' "${HOME}/.zprofile" "${HOME}/.p10k.zsh"
fi

# ── OMP plugin manifests: only when ~/.omp is actually in use ─────────
if [[ "${IS_MACOS}" -eq 1 || -d "${HOME}/.omp" ]]; then
  link_file "${ROOT_DIR}/omp/plugins/package.json"          "${HOME}/.omp/plugins/package.json"
  link_file "${ROOT_DIR}/omp/plugins/omp-plugins.lock.json" "${HOME}/.omp/plugins/omp-plugins.lock.json"
else
  printf 'skipped (~/.omp not in use): OMP plugin manifests\n'
fi

# ── Editable git config: created once, never overwritten ──────────────
if [[ ! -e "${HOME}/.gitconfig" ]]; then
  run cp "${ROOT_DIR}/git/.gitconfig.example" "${HOME}/.gitconfig"
  printf 'created editable git config: %s\n' "${HOME}/.gitconfig"
else
  printf 'skipped existing git config: %s\n' "${HOME}/.gitconfig"
fi

printf '\nInstall complete.'
if [[ "${DRY_RUN}" -eq 1 ]]; then
  printf ' (dry run — nothing was changed)'
fi
printf '\n'

if [[ "${IS_MACOS}" -eq 1 ]]; then
  printf 'Next: brew bundle --file "%s/Brewfile", then restart your shell.\n' "${ROOT_DIR}"
else
  printf 'Next: install the tools you need with your system package manager\n'
  printf '      (the Brewfile is macOS-only; see README.md), then restart your shell.\n'
fi
