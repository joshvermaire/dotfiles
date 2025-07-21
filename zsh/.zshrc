# -- Powerlevel10k: instant prompt (speeds up initial prompt rendering) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- Paths ----------------------------------------------------------------
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Clean $PATH: remove duplicates
typeset -gU PATH path

# Completion cache (speeds up compinit from ~50 ms → ~5 ms)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.cache/zsh/completion

# -- Antidote ---------------------------------------------------------------
source ~/.antidote/antidote.zsh
[[ -f ~/.zsh_plugins.zsh ]] && source ~/.zsh_plugins.zsh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# -- Ruby ---------------------------------------------------------------
eval "$(rbenv init - zsh)"

# -- NVM ---------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -- Bun ---------------------------------------------------------------
[ -s "/Users/jvermaire/.bun/_bun" ] && source "/Users/jvermaire/.bun/_bun"

# -- Dotfiles ---------------------------------------------------------------
source ~/.zsh_profile
source ~/.zsh_aliases
source ~/.zsh_functions
source ~/.zsh_secrets

# -- Tizen ---------------------------------------------------------------
export TIZEN_SDK_ROOT="$HOME/tizen-studio"
export PATH="$PATH:$TIZEN_SDK_ROOT/tools/ide/bin:$TIZEN_SDK_ROOT/tools/tizen-core"

# -- Compinit ---------------------------------------------------------------
autoload -Uz compinit
compinit