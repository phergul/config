if [[ $OSTYPE == darwin* ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  if [[ -n $HOMEBREW_PREFIX ]]; then
    path=("$HOMEBREW_PREFIX/opt/node@22/bin" "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
  fi
fi
typeset -U path
path=("$HOME/bin" "$HOME/go/bin" $path)
export PATH
