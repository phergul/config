export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting sudo)

source $ZSH/oh-my-zsh.sh

eval "$(ssh-agent -s)" >> /dev/null
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
fpath+=("$HOME/.zsh/completions")
autoload -Uz compinit
compinit

### Path
export PATH="$HOME/bin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"


### Scripts
for file in "$HOME/scripts"/*.sh; do
	[ -r "$file" ] && source $file
done


### Environment Variables
export EDITOR="nvim"


### alias

alias zshcfg="nvim ~/.zshrc"
alias vim="nvim"
alias cd="z"
alias ls="eza"
alias lst="eza -T -L 1"
alias zellijclean="zellij --kill-all-sessions"


### git alias

alias ga="git add"
alias gaa="git add ."
alias gcm="git commit -m"
alias gp="git push origin"
alias gpl="git pull"
alias gk="git checkout"
alias gkb="git checkout -b"
alias gs="git status"
alias gsl="git stash list"
alias gsp="git stash push"
alias gspop="git stash pop"
alias gf="git reflog"


### Functions
