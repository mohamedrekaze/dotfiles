# # ---- pyenv (must be first) ----
# export PATH="$HOME/.pyenv/shims:$HOME/.pyenv/bin:$PATH"
# eval "$("$HOME/.pyenv/bin/pyenv" init --no-rehash -)"
#
# # ---- NVM ----
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
# nvm use default >/dev/null
#
#
# # ---- Base user paths (append only) ----
# export PATH="$PATH:$HOME/bin"
# export PATH="$PATH:$HOME/.local/bin"
# export PATH="$PATH:$HOME/Library/Python/3.9/bin"
# export PATH="$PATH:$HOME/Downloads/nvim-macos-x86_64/bin"
# export PATH="$PATH:/opt/nvim"
# export PATH="$PATH:/snap/bin"
# export PATH="$PATH:/usr/local/bin"
# export PATH="$PATH:$HOME/goinfre/homebrew/bin"
# export PATH="$PATH:$HOME/homebrew/bin"
# export PATH="$PATH:$HOME/.local/homebrew/bin"
#
# # ---- Oh My Zsh ----
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
# source $ZSH/oh-my-zsh.sh
#
# # ---- Clean stray virtualenv ----
# if [[ -z "$(direnv export zsh 2>/dev/null)" && -n "$VIRTUAL_ENV" ]]; then
#   export PATH="${PATH//$VIRTUAL_ENV\/bin:/}"
#   unset VIRTUAL_ENV
# fi
#
# # ---- Prompt ----
# PROMPT='%c $ '
#
# # ---- Aliases ----
# alias nv="nvim"
# alias bp="bpytop"
# alias ff="fastfetch"
# alias tmux="tmux -f ~/.config/tmux/tmux.conf"
# alias tml="tmux ls"
# alias tmn="tmux new -s"
# alias tma="tmux a -t"
# alias tmd="tmux detach"
# alias tmt="tmux select-layout even-vertical"
# alias francinette="$HOME/francinette/tester.sh"
# alias p="python3"
#
# # ---- Completion ----
# autoload -U compinit
# compinit
# zstyle ':completion:*' menu select=2
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
#
# # ---- Custom scripts ----
# source ~/.42-wizzard.sh
# zsh ~/.42-wizzard-updater.sh
# code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}
#
#
#
#
















# ---- pyenv (must be first) ----
export PATH="$HOME/.pyenv/shims:$HOME/.pyenv/bin:$PATH"
eval "$("$HOME/.pyenv/bin/pyenv" init --no-rehash -)"

# ---- NVM (must load before system Node paths) ----
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
nvm use default >/dev/null

# ---- Base user paths (append only) ----
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/Library/Python/3.9/bin"
export PATH="$PATH:$HOME/Downloads/nvim-macos-x86_64/bin"
export PATH="$PATH:/opt/nvim"
export PATH="$PATH:/snap/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/goinfre/homebrew/bin"
export PATH="$PATH:$HOME/homebrew/bin"
export PATH="$PATH:$HOME/.local/homebrew/bin"

# ---- Oh My Zsh ----
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ---- Completion (after Oh My Zsh) ----
autoload -U compinit
compinit -i
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ---- Clean stray virtualenv ----
if [[ -z "$(direnv export zsh 2>/dev/null)" && -n "$VIRTUAL_ENV" ]]; then
  export PATH="${PATH//$VIRTUAL_ENV\/bin:/}"
  unset VIRTUAL_ENV
fi

# ---- Prompt ----
PROMPT='%c $ '

# ---- Aliases ----
alias nv="nvim"
alias bp="bpytop"
alias ff="fastfetch"
alias tmux="tmux -f ~/.config/tmux/tmux.conf"
alias tml="tmux ls"
alias tmn="tmux new -s"
alias tma="tmux a -t"
alias tmd="tmux detach"
alias tmt="tmux select-layout even-vertical"
alias francinette="$HOME/francinette/tester.sh"
alias p="python3"

# ---- Custom scripts ----
source ~/.42-wizzard.sh
zsh ~/.42-wizzard-updater.sh
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}
