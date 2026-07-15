#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_file() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "${target_path}")"

  if [[ -e "${target_path}" || -L "${target_path}" ]]; then
    if [[ "$(readlink "${target_path}" 2>/dev/null || true)" == "${source_path}" ]]; then
      printf 'already linked: %s\n' "${target_path}"
      return
    fi

    mkdir -p "${BACKUP_DIR}$(dirname "${target_path}")"
    mv "${target_path}" "${BACKUP_DIR}${target_path}"
    printf 'backed up: %s -> %s\n' "${target_path}" "${BACKUP_DIR}${target_path}"
  fi

  ln -s "${source_path}" "${target_path}"
  printf 'linked: %s -> %s\n' "${target_path}" "${source_path}"
}

link_file "${ROOT_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
link_file "${ROOT_DIR}/zsh/.zprofile" "${HOME}/.zprofile"
link_file "${ROOT_DIR}/zsh/.p10k.zsh" "${HOME}/.p10k.zsh"
link_file "${ROOT_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"
link_file "${ROOT_DIR}/vim/.vimrc" "${HOME}/.vimrc"
link_file "${ROOT_DIR}/vim/.vim/shared.vim" "${HOME}/.vim/shared.vim"
link_file "${ROOT_DIR}/nvim/init.vim" "${HOME}/.config/nvim/init.vim"
link_file "${ROOT_DIR}/nvim/lua/plugins.lua" "${HOME}/.config/nvim/lua/plugins.lua"
link_file "${ROOT_DIR}/nvim/lua/ide.lua" "${HOME}/.config/nvim/lua/ide.lua"
link_file "${ROOT_DIR}/nvim/lua/lsp.lua" "${HOME}/.config/nvim/lua/lsp.lua"
link_file "${ROOT_DIR}/git/.gitignore_global" "${HOME}/.gitignore_global"

if [[ ! -e "${HOME}/.gitconfig" ]]; then
  cp "${ROOT_DIR}/git/.gitconfig.example" "${HOME}/.gitconfig"
  printf 'created editable git config: %s\n' "${HOME}/.gitconfig"
else
  printf 'skipped existing git config: %s\n' "${HOME}/.gitconfig"
fi

printf '\nInstall complete. Restart your shell or run: source ~/.zshrc\n'
