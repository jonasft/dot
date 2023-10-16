# zsh terminal config
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# commands for macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="$(brew --prefix)/bin:$PATH" # Homebrew
    export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH" # Postgres
fi

# aliases
alias python=python3
alias py=python3
alias branch='git branch --sort=-committerdate | grep -v "^*" | fzf --no-sort --height=20% --reverse | xargs git checkout'

# personal git repos
if [ -d "$HOME/personal" ]; then
    export PATH="$PATH:$HOME/personal/openai-api/bin"
    alias important='cd ~/personal/vim'
fi

# init apps
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# source other envs
source $HOME/dot/oda_env.sh