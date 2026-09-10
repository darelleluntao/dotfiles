# ─────────────────────────────────────────────────────────────────
# Powerlevel10k instant prompt — must stay at the very top
# ─────────────────────────────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─────────────────────────────────────────────────────────────────
# PATH
# ─────────────────────────────────────────────────────────────────
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/fvm/versions/stable/bin:$PATH"
export PATH="$HOME/fvm/default/bin:$PATH"
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/go/bin:$PATH"

# Java & Android
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools"
[[ -d "$ANDROID_HOME/build-tools/37.0.0" ]] && export PATH="$PATH:$ANDROID_HOME/build-tools/37.0.0"

# .NET
export PATH="/opt/homebrew/opt/dotnet@6/bin:$PATH"
export DOTNET_ROOT="/opt/homebrew/opt/dotnet@6/libexec"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Misc tools
export PATH="$HOME/.flashlight/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# ─────────────────────────────────────────────────────────────────
# Locale
# ─────────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ─────────────────────────────────────────────────────────────────
# oh-my-zsh
# ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Completion styling (set before oh-my-zsh sources compinit)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings'     format '%F{red}-- no matches: %d --%f'
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'

plugins=(git)

source $ZSH/oh-my-zsh.sh

# zsh-autosuggestions and zsh-syntax-highlighting are brew-installed, source manually
if command -v brew >/dev/null 2>&1; then
  [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ─────────────────────────────────────────────────────────────────
# History
# ─────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS     # don't record a command run consecutively
setopt HIST_IGNORE_SPACE    # skip commands prefixed with a space
setopt HIST_VERIFY          # show expanded history before running
setopt SHARE_HISTORY        # share history between sessions
setopt EXTENDED_HISTORY     # save timestamp and duration

# ─────────────────────────────────────────────────────────────────
# Key bindings
# ─────────────────────────────────────────────────────────────────
bindkey '^[[1;5C' forward-word       # Ctrl+Right — jump word forward
bindkey '^[[1;5D' backward-word      # Ctrl+Left  — jump word backward
bindkey '^[[3~'   delete-char        # Delete key
bindkey '^U'      backward-kill-line # Ctrl+U — clear line to start

# ─────────────────────────────────────────────────────────────────
# Visual: colorized man pages
# ─────────────────────────────────────────────────────────────────
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# ─────────────────────────────────────────────────────────────────
# Visual: bat — syntax-highlighted cat
# ─────────────────────────────────────────────────────────────────
export BAT_THEME="Catppuccin Mocha"
alias cat="bat --style=plain --paging=never"

# ─────────────────────────────────────────────────────────────────
# Visual: eza — modern ls with icons + git status
# Requires a Nerd Font (font-hack-nerd-font is installed)
# ─────────────────────────────────────────────────────────────────
alias ls="eza --icons --color=always --group-directories-first"
alias ll="eza -la --icons --color=always --git --group-directories-first"
alias la="eza -a  --icons --color=always --group-directories-first"
alias lt="eza --tree --icons --color=always --level=2"
alias lta="eza --tree --icons --color=always --level=3 -a"

# ─────────────────────────────────────────────────────────────────
# fzf — fuzzy finder
# ─────────────────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use ripgrep for file listing (respects .gitignore)
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*' 2>/dev/null"

# Catppuccin Mocha palette + preview window
export FZF_DEFAULT_OPTS="
  --height=50% --layout=reverse --border=rounded
  --prompt='❯ ' --pointer='▶' --marker='✓'
  --color=fg:#cdd6f4,bg:#1e1e2e,hl:#89b4fa
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#89b4fa
  --color=info:#cba6f7,prompt:#cba6f7,pointer:#f5c2e7
  --color=marker:#a6e3a1,spinner:#f5c2e7,header:#89b4fa,border:#45475a
  --preview-window=right:50%:wrap
"

# Ctrl+R: fzf history search with preview
export FZF_CTRL_R_OPTS="
  --preview='echo {}'
  --preview-window=down:3:wrap
  --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header='Ctrl+Y to copy'
"

# Ctrl+T: file search with bat preview
export FZF_CTRL_T_OPTS="
  --preview='bat --color=always --style=numbers --line-range=:100 {}'
"

# Alt+C: directory jump with eza tree preview
export FZF_ALT_C_OPTS="
  --preview='eza --tree --icons --color=always --level=2 {}'
"

# ─────────────────────────────────────────────────────────────────
# Aliases — Shell
# ─────────────────────────────────────────────────────────────────
alias zshconfig="vim ~/.zshrc"
alias zshsource="source ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"

# ─────────────────────────────────────────────────────────────────
# Aliases — Navigation & Config
# ─────────────────────────────────────────────────────────────────
alias sshhome="cd ~/.ssh"
alias sshconfig="vim ~/.ssh/config"
alias gitconfig="vim ~/.gitconfig"

# ─────────────────────────────────────────────────────────────────
# Aliases — Git
# ─────────────────────────────────────────────────────────────────
alias gits="git status"
alias gitd="git diff"
alias gitl="git lg"
alias gita="git add ."
alias gitc="git commit"

# ─────────────────────────────────────────────────────────────────
# Aliases — Tools
# ─────────────────────────────────────────────────────────────────
alias dev="tmux attach -t dev || tmux new -s dev"
alias sublime="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl --new-window $@"
alias python3.11="/opt/homebrew/bin/python3.11"
alias pip3.11="/opt/homebrew/bin/python3.11 -m pip"

# ─────────────────────────────────────────────────────────────────
# Tool initializers
# ─────────────────────────────────────────────────────────────────

# nvm
[[ -f /opt/homebrew/opt/nvm/nvm.sh ]] && source /opt/homebrew/opt/nvm/nvm.sh

# Dart CLI completion
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# thefuck
command -v thefuck >/dev/null 2>&1 && eval "$(thefuck --alias)"

# zoxide (smart cd — use `z` to jump)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# Local env
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# Powerlevel10k (keep at end)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
export ECC_DISABLED_HOOKS=pre:edit-write:gateguard-fact-force,pre:bash:gateguard-fact-force

# Added by Antigravity IDE
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────────────────────────────────
# Isolated Cursor profile for personal (non-xpresstech) projects
# Keeps login/session separate from the default Cursor profile
# (which is signed into darelle.l@xpress.com.ph). Settings/snippets
# were copied over from the default profile so the experience is
# identical minus the login. Extensions dir is intentionally SHARED
# (not isolated) with the default profile so installed extensions
# stay in sync automatically. Skills, rules, and ~/.cursor/mcp.json
# are already global (outside any profile dir) so they're visible
# to both profiles without any copying.
# ─────────────────────────────────────────────────────────────────
export CURSOR_PERSONAL_PROFILE="$HOME/CursorProfiles/personal"
alias cursor-personal='/Applications/Cursor.app/Contents/Resources/app/bin/cursor --user-data-dir "$CURSOR_PERSONAL_PROFILE/user-data" --extensions-dir "$HOME/.cursor/extensions"'
alias commutr='cursor-personal "$HOME/Developer/Projects/commutr"'
alias os-start='cd "$HOME/Developer/Personal/personal-os" && ./start.sh'

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
