# Shared interactive-shell configuration used by Home Manager and standalone macOS.

alias zshsharedcfg='nvim ~/.config/zsh/common.zsh'
alias zshcfg='nvim ~/.zshrc.local'
alias vim='nvim'
alias cd='z'
alias ls='eza'
alias lst='eza -T -L 1'
alias zellijclean='zellij kill-all-sessions'
alias ga='git add'
alias gaa='git add .'
alias gcm='git commit -m'
alias gp='git push origin'
alias gpl='git pull'
alias gk='git checkout'
alias gkb='git checkout -b'
alias gs='git status'
alias gsl='git stash list'
alias gsp='git stash push'
alias gspop='git stash pop'
alias gf='git reflog'

if [ -d "$HOME/scripts" ]; then
  for file in "$HOME/scripts"/*.sh(N); do
    [ -r "$file" ] && source "$file"
  done
fi

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
