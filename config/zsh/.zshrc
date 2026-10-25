source "${${(%):-%N}:A:h}/paths.zsh"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git sudo)
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  # Keep the dependency checkout unchanged; config updates are explicit.
  zstyle ':omz:update' mode disabled
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit
  compinit
fi

alias zshsharedcfg='nvim ~/.zshrc'
alias zshcfg='nvim ~/.zshrc.local'
alias vim=nvim
alias n=nvim
alias lg=lazygit
alias cd=z
alias ls=eza
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

if (( $+commands[fzf] )); then source <(fzf --zsh); fi
if (( $+commands[zoxide] )); then eval "$(zoxide init zsh)"; else unalias cd; fi
if (( $+commands[starship] )); then eval "$(starship init zsh)"; fi

if [[ -d "$HOME/scripts" ]]; then
  for file in "$HOME/scripts"/*.sh(N); do
    [[ -r "$file" ]] && source "$file"
  done
  unset file
fi
[[ ! -r "$HOME/.zshrc.local" ]] || source "$HOME/.zshrc.local"

# Homebrew and Arch use different directories beneath their share prefix.
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  for file in "${HOMEBREW_PREFIX:-/usr}/share/$plugin/$plugin.zsh" \
              "${HOMEBREW_PREFIX:-/usr}/share/zsh/plugins/$plugin/$plugin.zsh"; do
    if [[ -r "$file" ]]; then
      source "$file"
      break
    fi
  done
done
unset plugin file
